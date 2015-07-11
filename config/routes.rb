Rails.application.routes.draw do
  namespace :explore do
    resources :books, only: [:index, :show]
    resources :downloads, only: [:show]
    resources :authors, only: [:show]
  end

  resources :authors, only: [:edit, :update, :new, :create]
  resources :books, only: [:index, :show, :update, :create, :new] do
    resources :builds, only: [:create] do 
      collection do
        get 'hook'
      end
    end
  end


  get '/signin' => 'welcome#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#fail'
  get '/auth/:provider/callback' => 'sessions#create'

  match '/404', to: 'errors#file_not_found', via: :all

  root 'welcome#index'
end
