Rails.application.routes.draw do
  root 'welcome#index'
  resources :books
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post]
end
