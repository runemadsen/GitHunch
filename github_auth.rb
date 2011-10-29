class GithubAuth
  
  def initialize(client_id, client_secret, options)
    @client = OAuth2::Client.new('ea0fe732615aaa5329f8', 'c872fc1aa1927d1b1635f12e072ef02e14c9e1d2', options)
  end
  
  def authorize_url
    @client.auth_code.authorize_url
  end
  
  def token(code)
    @token ||= @client.auth_code.get_token(code)
    @token.token
  end
  
  def repos
    @repos ||= @token.get('http://api.github.com/user/repos')
  end
  
end