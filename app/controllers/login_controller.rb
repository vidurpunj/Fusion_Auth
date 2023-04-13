class LoginController < ApplicationController
  def create
    @oauth_client = OAuth2::Client.new('e4bc44b7-feed-4f73-93d8-a966dcffa200',
                                       '6HC7j14y0l9unmKabtvtB0Mj5KfFU7aNjYdEnqBRDjw',
                                       authorize_url: 'http://localhost:9011/oauth2/authorize',
                                       site: 'https://de15-111-93-193-70.in.ngrok.io',
                                       token_url: '/oauth2/token',
                                       redirect_uri: 'https://de15-111-93-193-70.in.ngrok.io/oauth2-callback')
    # Make a call to exchange the authorization_code for an access_token
    response = @oauth_client.auth_code.get_token(params[:code])

    # Extract the access token from the response
    token = response.to_hash[:access_token]

    # Decode the token
    begin
      decoded = TokenDecoder.new(token, @oauth_client.id).decode
    rescue Exception => error
      "An unexpected exception occurred: #{error.inspect}"
      head :forbidden
      return
    end

    # Set the token on the user session
    session[:user_jwt] = {value: decoded, httponly: true}

    redirect_to root_path
  end
end
