Rails.application.routes.draw do
  get 'user/create'
  get 'user/register'
  get 'home/index'
  root to: 'home#index'
  get '/oauth2-callback', to: 'o_auth#oauth_callback'
  get '/logout', to: 'o_auth#logout'
  get '/login', to: 'o_auth#login'
  get '/after_login', to: 'login#create'
  get '/reset_sessions', to: 'o_auth#reset_sessions'
end
