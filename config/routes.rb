Rails.application.routes.draw do

  # Home controller routes
  root 'home#index'
  get 'auth'                => 'home#auth'

  # Get login token from Knock
  post 'user_token'         => 'user_token#create'

  # User action
  get     '/users'          => 'users#index'
  get     '/user/current'   => 'users#current'
  post    '/user'           => 'users#create'
  patch   '/user/:id'       => 'users#update'
  delete  '/user/:id'       => 'users#destroy'
end
