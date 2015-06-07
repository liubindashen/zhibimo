Rails.application.routes.draw do
  scope '/api/v1' do
    resources :explore, only: [:index, :show]

    resources :books do
      member do
        post 'build'
        post 'hook'
      end
      resources :entries, only: [:index, :create, :show, :update, :destroy]
    end
  end

  match '/auth/wechat/callback' => 'sessions#create_with_wechat', via: [:get, :post]
  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post], as: :signin
  get "/signout" => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#fail'

  root 'welcome#index'
end
