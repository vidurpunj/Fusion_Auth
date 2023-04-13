class OAuthController < ApplicationController
  def initialize
    @oauth_client = OAuth2::Client.new(ENV['FUSION_AUTH_CLIENT_ID'],
                                       ENV['FUSION_AUTH_CLIENT_SECRET'],
                                       authorize_url: "#{ENV['FUSION_AUTH_APPLICATION_URL']}/oauth2/authorize",
                                       site: ENV['WEBSITE_URL'],
                                       token_url: "#{ENV['FUSION_AUTH_APPLICATION_URL']}/oauth2/token",
                                       redirect_uri: "#{ENV['WEBSITE_URL']}/oauth2-callback")
  end

  def oauth_callback
    # Make a call to exchange the authorization_code for an access_token
    response = @oauth_client.auth_code.get_token(params[:code])
    token = response.to_hash[:access_token]
    # Decode the token
    begin
      decoded = TokenDecoder.new(token, @oauth_client.id).decode
    rescue Exception => error
      "An unexpected exception occurred: #{error.inspect}"
      head :forbidden
      return
    end

    user =  User.find_by(email: decoded[0]["email"])
    if user
      session[:email] =  user.email
    else
      @user = User.create({
                            aud: decoded[0]["aud"],
                            exp: decoded[0]["exp"],
                            iat: decoded[0]["iat"],
                            iss:decoded[0]["iss"],
                            sub:decoded[0]["sub"],
                            jti:decoded[0]["jti"],
                            authenticationType: decoded[0]["authenticationType"],
                            email: decoded[0]["email"],
                            email_verified: decoded[0]["email_verified"],
                            preferred_username: decoded[0]["preferred_username"],
                            auth_time:decoded[0]["auth_time"],
                            tid:decoded[0]["tid"]
                          })
      session[:email] =  @user.email
    end
    # Set the token on the user session
    session[:user_jwt] = {value: decoded, httponly: true}
    redirect_to root_path
  end

  def logout
    if session[:email]
      user = User.find_by(email: session[:email])
      auth_id = user.aud
      redirect_to "#{ENV["FUSION_AUTH_APPLICATION_URL"]}/oauth2/logout?client_id=#{auth_id}", allow_other_host: true
    else
      redirect_to root_path
    end
  end

  def reset_sessions
    reset_session
    session.clear
    redirect_to root_path
  end
  def login
    # redirect_to @oauth_client.auth_code.authorize_url
    redirect_to(@oauth_client.auth_code.authorize_url, allow_other_host: true)
  end
end
