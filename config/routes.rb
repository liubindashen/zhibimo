Rails.application.routes.draw do
  resources :books

  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post], as: :signin
  get "/signout" => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#fail'

  root 'welcome#index'
end
