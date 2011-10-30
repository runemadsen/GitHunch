require 'bundler'
Bundler.require
require './github'
require './helpers'

enable :sessions

get '/' do

  # session[:access_token] = nil

  unless session[:access_token]
    redirect GithubOAuth.authorize_url('ea0fe732615aaa5329f8', 'c872fc1aa1927d1b1635f12e072ef02e14c9e1d2')
  end
  
  @github = Github.new(session[:access_token])
  
  # if repo doesn't exist, we create it
  if(@github.repo("githunch_bookmarks").response.is_a?(Net::HTTPNotFound))
    
    puts "Creating repo"
    @github.create_repo("githunch_bookmarks")
    
    puts "Creating Tree"
    tree_result = @github.create_tree("githunch_bookmarks", "[]", "bookmarks.json")
    puts "Tree sha #{tree_result["sha"]}"
    
    puts "Creating commit"
    commit_result = @github.create_initial_commit("githunch_bookmarks", tree_result["sha"], "Creating githunch files")
    puts "Commit sha #{commit_result["sha"]}"
    
    puts "Creating ref"
    ref_result = @github.create_ref("githunch_bookmarks", "refs/heads/master", commit_result["sha"])
    puts "Ref: #{ref_result["sha"].inspect}"
    
  end
  
  erb :index
  
end

get '/oauth' do
  session[:access_token] = GithubOAuth.token('ea0fe732615aaa5329f8', 'c872fc1aa1927d1b1635f12e072ef02e14c9e1d2', params[:code])
  redirect '/'
end

post '/bookmarks' do
    "Post to Github"
end