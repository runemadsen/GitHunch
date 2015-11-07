require 'bundler'
Bundler.require
require './helpers'

# TODO: Change initializers to hash
# TODO: When querying the API, throw validation errors if user, repo, etc is not set

enable :sessions

if settings.environment == :development
  credentials = { :id => "REPLACEME", :secret => "REPLACEME"}
else
  credentials = { :id => "REPLACEME", :secret => "REPLACEME"}
end

get '/' do
  
  # check oauth
  unless session[:access_token]
    redirect GithubOAuth.authorize_url(credentials[:id], credentials[:secret])
  end
  
  @user = GithubApi::User.new(session[:access_token])
  
  # if the user doesn't have write permissions, get a new cookie
  # (happens if token is revoked from github)
  
  if(not @user.has_repo?("githunch_bookmarks"))
    
    repo = @user.create_repo("githunch_bookmarks", {
      :description => "Repository for Githunch Bookmarks",
      :homepage => "http://githunch.heroku.com",
      :public => true,
      :has_issues => false,
      :has_wiki => false,
      :has_downloads => false
    })
    
    file = GithubApi::Blob.new(:content => "this is my content", :path => "bookmarks.json")
    tree = repo.create_tree([file])
    commit = repo.create_initial_commit(tree.data["sha"], "This is my commit text")    
    reference = repo.create_ref("refs/heads/master", commit.data["sha"])
    
    # just dummy for now
    @bookmarks = {}
  else
    repo = @user.repo("githunch_bookmarks")
    blob = repo.ref("heads/master").commit.tree.file("bookmarks.json")
    @bookmarks = JSON.parse(blob.content)
  end

  erb :index

end

get '/oauth' do
  session[:access_token] = GithubOAuth.token('REPLACEME', 'REPLACEME', params[:code])
  redirect '/'
end

post '/bookmarks' do
  @user = Github::User.new(session[:access_token])
  bookmark = Bookmark.new(params[:bookmark])
  #  more stuff here
end
