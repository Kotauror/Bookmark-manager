## ex. 1 Creating User Stories
## ex. 2 setup project
```plain
$ rspec --init
$ bundle init (creates gemfile)
$ rvm list
$ rvm use 2.5.0
$ rvm --default use 2.5.0
```
Inside gemfile
```plain
source 'https://rubygems.org'

gem 'sinatra'
gem 'rspec'
gem 'capybara'
```
Useful rspec methods
```plain
$ rspec -fd  (shows tests with headings)
$ for i in `seq 50` ; do rspec spec ; [[ ! $? = 0 ]] && break ; done (runs 50 tests)
$ rspec --fail-fast
```
```plain
$ rspec -fd  (shows tests with headings)
$ for i in `seq 50` ; do rspec spec ; [[ ! $? = 0 ]] && break ; done (runs 50 tests)
$ rspec --fail-fast
```
```ruby
require 'sinatra/base' in app.rb
class BookmarkManager < Sinatra::Base

  run! if app_file == $0
end
```
In spec_helper:
```ruby
ENV['RACK_ENV'] = 'test'
require File.join(File.dirname(__FILE__), '..', 'app.rb')
require 'capybara'
require 'capybara/rspec'
require 'rspec'
require_relative './features/web_helpers'

Capybara.app = BookmarkManager
```
In config.ru
```plain
require_relative "./app"
run BookmarkManager
```

## ex. 3 Creating postgres database
- to enter a database and open postgresql irb type
```plain
$ psql postgres
```
- create a database
```plain
$ psql postgres
$ CREATE DATABASE "your_user_name_here";
```
- list all of the databases
```plain
$ \l
```
- quit `psql`
```plain
$ \q
```
### postgres cheat sheet
https://blog.jasonmeridth.com/posts/postgresql-command-line-cheat-sheet/

## ex. 4
Connect to database in postgres (first enter postgres by `psql postgres`)
```plain
\c bookmark_manager
```
Creating table in postgres
```plain
CREATE TABLE weather (
    city            varchar(80),
    temp_lo         int,           -- low temperature
    temp_hi         int,           -- high temperature
    prcp            real,          -- precipitation
    date            date
);
```
Enter the table (show columns)
```plain
\d tablename
```
varchar - character varying - text limited in charactes (eg. to 60).

## ex 5 - Insert to / delete from table

Nice explanation of insertion :)
```plain
CREATE TABLE lists(id serial, col2 text, col3 text, ...);
      *If you don't specify "id", it will autogenerate for you:*
INSERT INTO lists(col2, col3, ...) VALUES('KO','SPH', ...);
      *You can also specify using DEFAULT (the same as above):*
INSERT INTO lists(id, col2, col3, ...) VALUES(DEFAULT, 'KO','SPH', ...);
```
Add stuff to increment ID (since it's `SERIAL` type)
```plain
INSERT INTO links (url) VALUES ('http://www.makersacademy.com');
```
Select all stuff from table
```plain
SELECT * FROM table;
```
Delete stuff
```plain
DELETE FROM links WHERE id = 3;
DELETE FROM links WHERE url = 'http://www.twitter.com';
```
Update stuff
```plain
UPDATE links SET url = 'http://www.google.com' WHERE id = 2
UPDATE links SET url = 'http://www.google.com' WHERE url = 'http://www.askjeeves.com';
```

### ex 6 Interacting with PostgreSQL from Ruby
--> remove the hard-coded array of links and read them from a database instead.

```ruby
# Inside lib/link.rb
require 'pg'

class Link
  def self.all
    connection = PG.connect(dbname: 'bookmark_manager')
    result = connection.exec("SELECT * FROM links")
    result.map { |link| link['url'] }
  end
end
```
```plain
connection = PG.connect(dbname: 'bookmark_manager')
```
We ask the PG class (provided by the pg gem) to connect to the database called 'bookmark manager'. It returns a connection (which we store in a variable called connection). We can ask connection to do things, like query the database.
```plain
result = connection.exec("SELECT * FROM links")
```
We ask the connection to execute some SQL: SELECT * FROM links. This SQL will fetch all links, and the resulting 'result object' is stored in a variable called result.
```plain
result.map { |link| link['url'] }
```
The result object contains the links, each of which is a hash of the link ID and link URL. We map each hash to the url key of the hash. This gives us an array of the link URLs.

## Exercise 7 - TablePlus

When using TablePlus click on 'Navigate' then 'Switch database' and select the database required. Any tables should then appear under 'Items'.

Click on the command line button (top left) to open a new SQL query. Use `SELECT`, `FROM` etc to interact with the database.

When executing two commands use a semi-colon at the end of the first command

```plain
INSERT INTO links(url) VALUES (’http://www.theguardian.com');
SELECT * FROM links
```

Don't leave old commands in the query because they will be re-run and create multiple entries

To delete mulitple entries in one go:

```plain
DELETE FROM links WHERE id IN (8, 9, 10);
SELECT * FROM links;
```
## 8 Exercise 8 - seting up a testing environment
CREATE DATABASE 'bookmark_manager_test';
\c bookmark_manager_test
CREATE TABLE links(id SERIAL PRIMARY KEY, url VARCHAR(60));

ENV['ENVIRONMENT'] = 'test'in spec_helper.rb - sets the environment to test status.
Spec_helper.rb file is run only when using rspec. When we use rackup, we don't run this file, so the enviroment won't be the test environment.

```ruby
# in lib/link.rb
require 'pg'

class Link
  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmark_manager')
    end

    result = connection.exec("SELECT * FROM links")
    result.map { |link| link['url'] }
  end
end
```
Here we tell our link class that if the enviroment is test (it is when rspec), then load links from test database. Otherwise (when rackup) - load from normal db.


We create test_database_setup in spec folder, where we load the data to our test database. THen, before running rspec, we run
```plain
$ ruby spec/test_database_setup.rb
```

connection.exec("TRUNCATE links;") - clears database of all data. We can run the ruby spec/test_database_setup.rb + rspec sequence many times in a row.

Instead of running spec/test_database_setup.rb + rspec each time, we can require the test_database_setup file in the spechelper by typing:

```ruby
# in spec_helper.rb
config.before(:each) do
  require_relative './test_database_setup'
end
```

## ex. 10

Instead of having this long logic in `Link` class:
```ruby
+  def self.create(hash)
+    if ENV['ENVIRONMENT'] == "test"
+      connection = PG.connect(dbname: 'bookmark_manager_test')
+    else
+      connection = PG.connect(dbname: 'bookmark_manager')
+    end
+    connection.exec("INSERT INTO links (url) VALUES('#{hash[:url]}')")
+  end
```
We're goin to create a new `DatabaseConnection` to:
* setup the connection at the boot of the application
  * in order to do it automatically once we run the application, we need to`require './database_connection_setup'` in the app.rb file.
  * inside of `./database_connection_setup` file we specify which database do we want to connect to.
   ```ruby
   # inside database_connection_setup.rb
   require './lib/database_connection'

   if ENV['ENVIRONMENT'] == 'test'
     DatabaseConnection.setup('bookmark_manager_test')
   else
     DatabaseConnection.setup('bookmark_manager')
   end
   ```
  * `'./database_connection_setup'` is calling a `setup` method on `DatabaseConnection` (it knows this class because we require the file at the top) with an argument of a database.
  * this method is creating a connection.

  ```ruby
  # inside database_connection.rb
  class DatabaseConnection
    def self.setup(database_name)
      @connection = PG.connect(dbname: database_name)
    end
  ```
  * Now the connection is created and we don't need to do it manually.
* query the database.
  * `DatabaseConnection` has also additional method - `query` - which allows to create and execute queries in the database (picked in `setup`).
  * How it works inside the Link class:

  ```ruby
  require 'pg'
  require 'database_connection'

  class Link

    def self.all
      result = DatabaseConnection.query("SELECT * FROM links")
      result.map { |link| link['url'] }
    end

    def self.create(hash)
      DatabaseConnection.query("INSERT INTO links (url) VALUES('#{hash[:url]}')")
    end

  end
  ```
  The method `query` itself:
  ```ruby
  class DatabaseConnection
    def self.query(sql)
     @connection.exec(sql)
    end
  end
  ```
> Note: we're using class methods on DatabaseConnection because our DatabaseConnection is never going to be instantiated. It's a 'Singleton' object: there's only one DatabaseConnection in the application.

## ex 11

right now people, in order to use our programm, need to have databases : bookmark_manager and bookmark_manager_test. To make it easier for them, we can use Rake - a task runner - o automate the tasks of setting up the database. 
