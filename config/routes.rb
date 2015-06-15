Rails.application.routes.draw do
  scope '/api/v1' do
    resources :books do
      member do
        post 'build'
        post 'hook'
      end
      resources :entries, only: [:index, :create, :show, :update, :destroy]
    end
  end

  get  '/signin' => 'welcome#new', as: :signin
  get  '/signout' => 'sessions#destroy', as: :signout
  get  '/auth/failure' => 'sessions#fail'
  post '/auth/:provider/callback' => 'sessions#create'

  resources :explore, only: [:show, :index]

  root 'welcome#index'
end
