Rails.application.routes.draw do
  scope '/api/v1' do
    resources :explore, only: :index

    resources :books do
      member do
        post 'hook'
      end
      resources :entries, only: [:index, :create, :show, :update, :destroy]
    end
  end

  match '/auth/:provider/callback' => 'sessions#create', via: [:get, :post], as: :signin
  get "/signout" => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#fail'

  root 'application#index'
  get "/editor/:id" => "application#editor"
  get "*path" => "application#index"
  get "*path.html" => "application#index", :layout => nil
end
