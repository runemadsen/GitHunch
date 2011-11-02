require 'bundler'
Bundler.require
require './github/github'
require './helpers'

enable :sessions

if settings.environment == :development
  credentials = { :id => "ea0fe732615aaa5329f8", :secret => "c872fc1aa1927d1b1635f12e072ef02e14c9e1d2"}
else
  credentials = { :id => "9d90f769f7a70a82acb7", :secret => "4b7985b7bc627fe9a1e7fed26f7529d6de9a25ca"}
end

get '/' do
  
  # check oauth
  unless session[:access_token]
    redirect GithubOAuth.authorize_url(credentials[:id], credentials[:secret])
  end
  
  @user = Github::User.new(session[:access_token])
  
  if(not @user.has_repo?("githunch_bookmarks"))
    
    repo = @user.create_repo("githunch_bookmarks", {
      :description => "Repository for Githunch Bookmarks",
      :homepage => "http://githunch.heroku.com",
      :public => true,
      :has_issues => false,
      :has_wiki => false,
      :has_downloads => false
    })
    
    blob = Github::Blob.new("this is my content", "bookmarks.json")
    tree = repo.create_tree([blob])
    commit = repo.create_initial_commit(tree.sha, "This is my commit text")
    reference = repo.create_ref("refs/heads/master", commit.sha)
  end
  
  # find bookmarks file, dummy code
  repo = @user.find_repo("githunch_bookmarks")
  blob = repo.find_ref("heads/master").file("bookmarks.json")

  erb :index

end

get '/oauth' do
  session[:access_token] = GithubOAuth.token('ea0fe732615aaa5329f8', 'c872fc1aa1927d1b1635f12e072ef02e14c9e1d2', params[:code])
  redirect '/'
end

post '/bookmarks' do
  @user = Github::User.new(session[:access_token])
  bookmark = Bookmark.new(params[:bookmark])
  #  more stuff here
end