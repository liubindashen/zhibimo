Rails.application.routes.draw do
  get '/signin' => 'welcome#new', as: :signin
  get '/signout' => 'sessions#destroy', as: :signout
  get '/auth/failure' => 'sessions#fail'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth' => 'sessions#auth'

  get '/explore/books', to: 'books#index', as: :explore_books
  get '/explore/authors', to: 'authors#index', as: :explore_authors

  # custom path helper in application
  get '/books/:author', to: 'authors#show' # author_path(@book)
  get '/books/:author/:slug', to: 'books#show' # book_path(@book)

  get '/register', to: 'users#edit', as: :register
  post '/register', to: 'users#update'

  namespace :reader do
    resources :books, only: [:index] do
      resources :donates, only: [:new, :show, :create] do
        member do
          post :callback
        end
      end
      resources :purchases, only: [:show, :create] do
        member do
          post :callback
        end
      end
    end
  end

  namespace :writer do
    resource :profile, only: [:new, :create, :edit, :update]
    resources :orders, only: [:index, :show]

    resources :books, only: [:index, :edit, :update, :create, :new] do
      resources :orders, only: [:index]

      resource :desk, only: [:show]
      resource :covers, only: [:edit, :update]
      resource :purchase, only: [:edit, :update]

      resources :builds, only: [:update, :index] do
        collection do
          post 'hook'
        end
      end
    end
  end

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

  ActiveAdmin.routes(self)

  %w(400 404 422 500).each do |code|
    get code, to: "errors#show", code: code
  end

  root 'welcome#index'
end
