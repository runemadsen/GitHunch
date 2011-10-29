require 'bundler'
Bundler.require

def github_client
  OAuth2::Client.new('ea0fe732615aaa5329f8', 'c872fc1aa1927d1b1635f12e072ef02e14c9e1d2', :authorize_url => 'https://github.com/login/oauth/authorize', :token_url => 'https://github.com/login/oauth/access_token')
end

get '/' do
  redirect github_client.auth_code.authorize_url(:redirect_uri => 'http://githunch.heroku.com/oauth')
end

get '/oauth' do
  access_token = github_client.auth_code.get_token.get_access_token(params[:code], :redirect_uri => 'http://githunch.heroku.com/oauth')  
  session[:access_token] = access_token.token
    # @message = JSON.parse(access_token.get('/api/v1/data.json'))
  "Succes: #{access_token}"
end