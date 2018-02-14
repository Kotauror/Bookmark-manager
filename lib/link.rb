require 'pg'
require_relative 'database_connection'

class Link

  attr_reader :id, :url, :title

  def initialize(id, url, title)
    @id = id
    @url = url
    @title = title
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM links")
    result.map { |link| Link.new(link['id'], link['url'], link['title']) }
  end

  def self.create(hash)
    DatabaseConnection.query("INSERT INTO links (url, title) VALUES('#{hash[:url]}', '#{hash[:title]}')")
  end

  def self.checkup(url)
    url[0..6] == 'http://' || url[0..2] == 'www' ? true : false
  end

  def self.delete(title)
    DatabaseConnection.query("DELETE FROM links WHERE title = '#{title}'")
  end

  def self.check_title(title)
    links = Link.all
    titles = links.map(&:title)
    titles.include?(title) ? true : false 
  end

end
