class HomeController < ApplicationController
  def index
    @user = User.find_by(email: session[:user_jwt]["value"][0]["email"]) if session[:user_jwt] && session[:user_jwt]["value"][0] && session[:user_jwt]["value"][0]["email"]
  end


end
