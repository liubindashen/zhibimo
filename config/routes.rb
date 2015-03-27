Rails.application.routes.draw do
  resources :books
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
end
