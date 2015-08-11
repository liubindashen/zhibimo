Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api do
    scope '/v1' do
      resources :books, only: [] do
        resources :entries, only: [:index, :create] do
          collection do
            get '*path', action: :show
            put '*path', action: :update
            post 'push', action: :push
          end
        end
      end
    end
  end

  namespace :explore do
    resources :books, only: [:index, :show] do
      resources :donates, only: [:new, :show, :create] do
        post :callback
      end
      resources :purchases, only: [:show, :create] do
        post :callback
      end
    end
    resources :downloads, only: [:show]
    resources :authors, only: [:show]
  end

  resource :author, only: [:edit, :update, :new, :create]

  resources :orders, only: [:index]

  resources :books, only: [:index, :edit, :update, :create, :new] do

    resource :desk, only: [:show]
    resource :purchase, only: [:edit, :update]

    resources :orders, only: [:index]
    resources :builds, only: [:update, :index] do
      collection do
        post 'hook'
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
