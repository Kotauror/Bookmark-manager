require 'pg'
require_relative 'database_connection'

class Link

  def self.all
    result = DatabaseConnection.query("SELECT * FROM links")
    result.map { |link| link['url'] }
  end

  def self.create(hash)
    DatabaseConnection.query("INSERT INTO links (url) VALUES('#{hash[:url]}')")
  end

  def self.checkup(url)
    url[0..6] == 'http://' || url[0..2] == 'www' ? true : false 
  end

end
