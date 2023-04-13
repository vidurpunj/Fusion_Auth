class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :logged_in?

  def current_user
    if session[:user_jwt] and (session[:user_jwt][:value] or session[:user_jwt]["value"])
      token = session[:user_jwt][:value]&.first || session[:user_jwt]["value"]&.first

      if token && token["email_verified"]
        @email = token["email"]
      else
        head :forbidden
        return
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def reset_session
    @_request.reset_session
  end
end
