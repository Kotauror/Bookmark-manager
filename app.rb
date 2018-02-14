require 'sinatra/base'
require './lib/link'
require './database_connection_setup'

class BookmarkManager < Sinatra::Base
  get "/" do
    @links = Link.all
    erb(:index)
  end

  get '/getlink' do
    erb(:getlink)
  end

  post "/url" do
    url = params[:url]
    @result = Link.checkup(url)
    @result == true ? Link.create(url: url) && redirect("/") : erb(:error)
  end

  run! if app_file == $0
end
