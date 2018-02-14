require 'pg'

task :test_database_setup do

  p "reset and repopulate database"

  connection = PG.connect(dbname: 'bookmark_manager_test')

  connection.exec("TRUNCATE links;")

  connection.exec("INSERT INTO links VALUES(1, 'http://www.makersacademy.com');")
  connection.exec("INSERT INTO links VALUES(2, 'http://www.google.com');")
  connection.exec("INSERT INTO links VALUES(3, 'http://www.facebook.com');")

end

task :setup do
  p "Creating databases"

  ["bookmark_manager", "bookmark_manager_test"].each do |database|
    connection = PG.connect
    connection.exec("CREATE DATABASE #{database}")
    connection = PG.connect(dbname: "#{database}")
    connection.exec("CREATE TABLE links(id SERIAL PRIMARY KEY, url VARCHAR(60));")
  end
end

# When we run this Rake task on a machine without bookmark_manager or
# bookmark_manager_test databases, it will create them for us.

# If we run this script on a machine that already has one of these databases,
# it fails. Can you adjust the script to handle the case of one or both
# databases already existing?
