class GithubAuth
  
  def initialize(client_id, client_secret)
    @client = OAuth2::Client.new(client_id, client_secret, :authorize_url => 'https://github.com/login/oauth/authorize', :token_url => 'https://github.com/login/oauth/access_token')
  end
  
  def authorize_url
    @client.auth_code.authorize_url(:scope => 'repo,gist')
  end
  
  def token(code)
    @token ||= @client.auth_code.get_token(code)
    @token.token
  end
  
  def repos
    @repos ||= @token.get('http://api.github.com/user/repos')
  end
  
end