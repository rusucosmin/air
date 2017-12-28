Rails.application.routes.draw do
  resources :buy_items
  resources :buy_lists
  match "*path",
    controller: "application",
    action: "handle_options_request",
    via: [:options]

  get 'jogging_logs/filter'   => 'jogging_logs#filter'
  get 'jogging_logs/raport'   => 'jogging_logs#raport'
  resources :jogging_logs
  get '/admin/jogging_logs'   => 'jogging_logs#index_admin'
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
