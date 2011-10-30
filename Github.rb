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
  
  def create_tree(repo_name, content)
    GithubApi3.post("/repos/#{user['login']}/#{repo_name}/git/trees", 
      :query => {
        :access_token => @token
      },
      :body => {
        :tree => [{
         :path => "myfile.txt",
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
  
  # Make a commit in just five easy* steps!
  # 
  #   After some investigating, I determined that the follow steps would result in a commit being added:
  # 
  #       GET /repos/:user/:repo/git/refs/heads/master
  #           Store the SHA for the latest commit (SHA-LATEST-COMMIT)
  # 
  #       GET /repos/:user/:repo/git/commits/SHA-LATEST-COMMIT
  #           Store the SHA for the tree (SHA-BASE-TREE)
  # 
  #       POST /repos/:user/:repo/git/trees/ while authenticated
  #           Set base_tree to be SHA-BASE-TREE
  #           Set path to be the full path of the file you are creating or editing
  #           Set content to be the full contents of the file
  #           From the response, get the top-level SHA (SHA-NEW-TREE)
  # 
  #       POST /repos/:user/:repo/git/commits while authenticated
  #           Set parents to be an array containing SHA-LATEST-COMMIT
  #           Set tree to be SHA-NEW-TREE
  #           From the response, get the top-level SHA (SHA-NEW-COMMIT)
  # 
  #       POST /repos/:user/:repo/git/refs/head/master while authenticated
  #           Set sha to be SHA-NEW-COMMIT
  #           You may need to set force to be true
  # 
  #   Now view your repository and make sure everything is correct. This approach skips the manual blob creation since setting tree.content automatically builds one for you. The /trees API also handles deep paths and recursively rewrites subtrees. These two shortcuts saved me an even bigger headache.
  # 
  #   I’d like to see some abstraction, as I mentioned before, where you can POST something like this and it would magically work:
  # 
  #    {
  #      "parent_commit": sha,
  #      "message": "commit msg",
  #      "content": [
  #          {
  #              "path":"path/to/file",
  #              "mode":"edit",
  #              "data":"editted version of file"
  #          },
  #          {
  #              "path":"path/to/new/file",
  #              "mode":"add",
  #              "data":"newly added file"
  #          }
  #      ]
  #    }
  # 
  #   There is likely lots of complexity with branches and doing less trivial commits, but for the simple use-case of making a new commit on the latest version on the master branch I think it could work.
  #   
end