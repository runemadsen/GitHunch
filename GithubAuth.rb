class GithubAuth
  
  def initialize(client_id, client_secret, options)
    @client = OAuth2::Client.new('REPLACEME', 'REPLACEME', options)
  end
  
  def authorize_url(options)
    @client.authorize_url(options)
  end
  
  def token(code)
    @client.get_token.get_access_token(code)  
  end
  
end
