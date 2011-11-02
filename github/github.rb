module Github
  
  #  TODO: New models should get passed a params object, and then use send to set the attributes
  #  TODO: New repos should get user name passed in params object to use when posting

  #  HTTP class
  # -------------------------------------

  class HTTP
    include HTTParty
    format :json
    base_uri 'https://api.github.com'
  end
  
  #  User class
  # -------------------------------------
  
  class User    
    
    def initialize(token)
      @token = token
      @repos = {}
    end
    
    def has_repo?(name)
      
    end
    
    def create_repo(name, params)
      body = {:name => name}.merge(params)
      
      response = Github::HTTP.post("/user/repos", 
        :query => { :access_token => @token},
        :body => body.to_json
      ).parsed_response
      
      @repos[name] = Repo.new(response)
    end
    
    def find_repo(name)
      
    end
    
  end
  
  #  Repo class
  # -------------------------------------
  
  class Repo
    
    attr_accessor :data, :name
    
    def initialize(data)
      @data = data
      @name = data[0]["name"]
      @trees = []
    end
    
    def create_tree(blobs)
      reponse = Github::HTTP.post("/repos/#{user['login']}/#{@name}/git/trees", 
        :query => {
          :access_token => @token
        },
        :body => {
          :tree => blobs
        }.to_json
      ).parsed_response
      
      @trees << Tree.new(response)
      
    end
    
    def create_initial_commit(sha, message)
      Github::HTTP.post("/repos/#{user['login']}/#{@name}/git/commits", 
        :query => {
          :access_token => @token
        },
        :body => {
          :message => message,
          :tree => sha
        }.to_json
      ).parsed_response
    end
    
    def create_ref(name, sha)
      
    end
    
    def find_ref(name)
      
    end
    
  end
  
  #  Reference class
  # -------------------------------------
  
  class Reference
    
  end
  
  #  Commit class
  # -------------------------------------
  
  class Commit
    
  end
  
  #  Blob class
  # -------------------------------------
  
  class Blob
    
    attr_accessor :content, :encoding
    
    def initialize(content, encoding)
      @content = content
      @encoding = encoding
    end
    
    def to_json(*a)
      {
        :content => @content,
        :encoding => @encoding
      }.to_json(*a)
    end
    
  end
  
  #  Tree class
  # -------------------------------------
  
  class Tree
    
    def initialize(data)
      @data = data
    end
    
  end

  class GithubApi
  
    def initialize(token)
      @token = token
      @repo_data = {}
      @commit_data = {}
    end
  
    def user
      @user ||= Github::HTTP.get("/user", :query => {:access_token => @token})
    end
  
    def repos
      @repos ||= Github::HTTP.get("/user/repos", :query => {:access_token => @token})
    end
  
    def repo(repo_name)
      @repo_data[repo_name] ||= Github::HTTP.get("/repos/#{user['login']}/#{repo_name}", :query => {:access_token => @token})
    end
  
    def reference(repo_name)
    
    end
  
    def commits(repo_name)
      @commit_data[repo_name] ||= Github::HTTP.get("/repos/#{user['login']}/#{repo_name}/commits", :query => {:access_token => @token}).parsed_response
    end
  
    def create_blob(repo_name, content)
      Github::HTTP.post("/repos/#{user['login']}/#{repo_name}/git/blobs", 
        :query => {
          :access_token => @token
        },
        :body => {
          :content => content,
          :encoding => "utf-8",
        }.to_json
      ).parsed_response
    end
  
    def create_ref(repo_name, ref_name, commit_sha)
      Github::HTTP.post("/repos/#{user['login']}/#{repo_name}/git/refs", 
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

end