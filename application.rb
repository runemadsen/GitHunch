require 'bundler'
Bundler.require
require './github'
require './github_auth'
require './helpers'

enable :sessions

get '/' do

  require_user
  
  @github = Github.new(session[:access_token])
  
  erb :index
end

get '/oauth' do
  session[:access_token] = github_client.token(params[:code])
  redirect '/'
end

post '/bookmarks' do
    "Post to Github"
end