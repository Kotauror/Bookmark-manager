require 'sinatra'
require 'sinatra/base'
require './lib/link'
require './database_connection_setup'
require 'uri'
require 'sinatra/flash'

class BookmarkManager < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  get '/' do
    @links = Link.all
    erb(:index)
  end

  get '/getlink' do
    erb(:getlink)
  end

  post '/url' do
    url = params[:url]
    title = params[:title]
    @result = Link.checkup(url)
    @result == true ? Link.create(url: url, title: title) : flash[:notice] = "You have submitted an invalid url"
    redirect("/")
  end

  get '/delete' do
    erb(:delete)
  end

  post '/delete' do
    title = params[:title]
    @result = Link.check_title(title)
    @result == true ? Link.delete(title) : flash[:notice] = "This title is not in the database"
    redirect('/')
  end

  get '/update' do
    erb(:update)
  end

  post '/update' do
    title = params[:title]
    new_title = params[:new_title]
    new_url = params[:new_url]
    @result = Link.check_title(title)
    @result == true ? Link.update(title, new_title, new_url) : flash[:notice] = "This title cannot be updated as it is not in the database"
    redirect('/')
  end


  run! if app_file == $0
end
