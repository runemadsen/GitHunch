class GithubAuth
  
  def initialize(client_id, client_secret, options)
    @client = OAuth2::Client.new('ea0fe732615aaa5329f8', 'c872fc1aa1927d1b1635f12e072ef02e14c9e1d2', options)
  end
  
  def authorize_url
    @client.authorize_url(:redirect_uri => 'http://githunch.heroku.com/oauth')
  end
  
  def token(code)
    @client.get_token.get_access_token(code)  
  end
  
end