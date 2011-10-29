helpers do
  
  def github_client
    GithubAuth.new('ea0fe732615aaa5329f8', 'c872fc1aa1927d1b1635f12e072ef02e14c9e1d2', :authorize_url => 'https://github.com/login/oauth/authorize', :token_url => 'https://github.com/login/oauth/access_token')
  end

  def require_user
    unless session[:access_token]
      redirect github_client.authorize_url
    end
  end
  
end