class GithubApi3
  include HTTParty
  format :json
  base_uri 'https://api.github.com'
end

class Github
  
  def initialize(token)
    @token = token
    @repo_data = {}
    @commit_data = {}
  end
  
  def user
    @user ||= GithubApi3.get("/user", :query => {:access_token => @token})
  end
  
  def repos
    @repos ||= GithubApi3.get("/user/repos", :query => {:access_token => @token})
  end
  
  def repo(repo_name)
    @repo_data[repo_name] ||= GithubApi3.get("/repos/#{user['login']}/#{repo_name}", :query => {:access_token => @token})
  end
  
  def commits(repo_name)
    @commit_data[repo_name] ||= GithubApi3.get("/repos/#{user['login']}/#{repo_name}/commits", :query => {:access_token => @token}).parsed_response
  end
  
  def create_repo(repo_name)
    @repo_data[repo_name] = GithubApi3.post("/user/repos", 
      :query => {
        :access_token => @token
      },
      :body => {
        :name => repo_name,
        :description => "Repository for Githunch Bookmarks",
        :homepage => "http://githunch.heroku.com",
        :public => true,
        :has_issues => false,
        :has_wiki => false,
        :has_downloads => false
      }.to_json
    ).parsed_response
  end
  
  def create_blob(repo_name, content)
    GithubApi3.post("/repos/#{user['login']}/#{repo_name}/git/blobs", 
      :query => {
        :access_token => @token
      },
      :body => {
        :content => content,
        :encoding => "utf-8",
      }.to_json
    ).parsed_response
  end
  
  def create_tree(repo_name, content, filename)
    GithubApi3.post("/repos/#{user['login']}/#{repo_name}/git/trees", 
      :query => {
        :access_token => @token
      },
      :body => {
        :tree => [{
         :path => filename,
         :content => content
        }]
      }.to_json
    ).parsed_response
  end
  
  def create_initial_commit(repo_name, tree_sha, message)
    GithubApi3.post("/repos/#{user['login']}/#{repo_name}/git/commits", 
      :query => {
        :access_token => @token
      },
      :body => {
        :message => message,
        :tree => tree_sha
      }.to_json
    ).parsed_response
  end
  
  def create_ref(repo_name, ref_name, commit_sha)
    GithubApi3.post("/repos/#{user['login']}/#{repo_name}/git/refs", 
      :query => {
        :access_token => @token
      },
      :body => {
        :ref => ref_name,
        :sha => commit_sha
      }.to_json
    ).parsed_response
  end
  
end