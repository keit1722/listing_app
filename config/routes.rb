require 'sidekiq/web'

Rails.application.routes.draw do
  root 'pages#home'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users, only: [] do
    member { get :activate }
  end

  get 'search', to: 'pages#search'

  resources :password_resets, only: %i[new create edit update]

  resources :restaurants, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :restaurants
    resources :posts, only: %i[index show], module: :restaurants
  end
  resources :shops, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :shops
    resources :posts, only: %i[index show], module: :shops
  end
  resources :hotels, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :hotels
    resources :posts, only: %i[index show], module: :hotels
  end
  resources :activities, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :activities
    resources :posts, only: %i[index show], module: :activities
  end
  resources :hot_springs, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :hot_springs
    resources :posts, only: %i[index show], module: :hot_springs
  end
  resources :ski_areas, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :ski_areas
    resources :posts, only: %i[index show], module: :ski_areas
  end
  resources :photo_spots, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :photo_spots
    resources :posts, only: %i[index show], module: :photo_spots
  end
  resources :notices, only: [] do
    patch :read, on: :member
  end

  namespace :mypage do
    get 'profile', to: 'users#show'
    patch 'profile', to: 'users#update'
    delete 'profile', to: 'users#destroy'
    get 'profile/edit', to: 'users#edit'
    resources :bookmarks, only: %i[index]
    resources :notices, only: %i[index]
  end

  resources :organizations, param: :slug do
    scope module: :organizations do
      resources :restaurants, param: :slug do
        resources :posts, module: :restaurants
      end
      resources :shops, param: :slug do
        resources :posts, module: :shops
      end
      resources :hotels, param: :slug do
        resources :posts, module: :hotels
      end
      resources :activities, param: :slug do
        resources :posts, module: :activities
      end
      resources :hot_springs, param: :slug do
        resources :posts, module: :hot_springs
      end
      resources :ski_areas, param: :slug do
        resources :posts, module: :ski_areas
      end
      resources :photo_spots, param: :slug do
        resources :posts, module: :photo_spots
      end
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
