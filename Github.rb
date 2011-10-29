class Github
  
  include HTTParty
  base_uri 'https://api.github.com'
  
  def initialize(token)
    @token = token
  end
  
  def user
    @user ||= self.class.get("/user?access_token=#{@token}")
  end
  
  def repos
    @repos ||= self.class.get("/user/repos?access_token=#{@token}")
  end
  
end