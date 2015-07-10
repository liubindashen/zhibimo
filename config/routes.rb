Rails.application.routes.draw do
  resources :explores, only: [:show, :index]
  resources :downloads, only: [:show]
  resources :authors, only: [:edit, :update, :new, :create, :show]

  resources :books do
    member do
      post 'build'
      post 'hook'
    end
    resources :entries, only: [:index, :create, :show, :update, :destroy]
  end

  get '/signin' => 'welcome#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#fail'
  get '/auth/:provider/callback' => 'sessions#create'


  match '/404', to: 'errors#file_not_found', via: :all

  ActiveAdmin.routes(self)

  root 'welcome#index'
end
