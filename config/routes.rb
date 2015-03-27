Rails.application.routes.draw do
  resources :books do
    resources :entries, only: [:index, :create, :show, :update, :destroy]
  end

  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post], as: :signin
  get "/signout" => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#fail'

  root 'application#index'
  get "*path.html" => "application#index", :layout => 0
  get "*path" => "application#index"
end
