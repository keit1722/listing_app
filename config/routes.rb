Rails.application.routes.draw do
  root 'pages#home'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get 'search', to: 'pages#search'

  resources :restaurants, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :restaurants
  end
  resources :shops, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :shops
  end
  resources :hotels, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :hotels
  end
  resources :activities, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :activities
  end
  resources :hot_springs, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :hot_springs
  end
  resources :ski_areas, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :ski_areas
  end
  resources :photo_spots, param: :slug, only: %i[index show] do
    collection { get 'search' }
    resource :bookmarks, only: %i[create destroy], module: :photo_spots
  end

  namespace :mypage do
    get 'profile', to: 'users#show'
    patch 'profile', to: 'users#update'
    delete 'profile', to: 'users#destroy'
    get 'profile/edit', to: 'users#edit'
  end

  resources :organizations, param: :slug do
    scope module: :organizations do
      resources :restaurants, param: :slug
      resources :hotels, param: :slug
      resources :activities, param: :slug
      resources :hot_springs, param: :slug
      resources :ski_areas, param: :slug
      resources :photo_spots, param: :slug
      resources :shops, param: :slug
    end
  end
end
