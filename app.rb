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
    # we pass a hash because of consistency priciple - self.all returns list of hashes,
    # so create should accept a hash as an argument.
    Link.create(url: params[:url])
    redirect("/")
  end

  run! if app_file == $0
end
