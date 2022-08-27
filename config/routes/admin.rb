namespace :admin do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  resources :organizations,
            param: :slug,
            only: %i[index edit update show destroy] do
    scope module: :organizations do
      resources :restaurants,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit update show destroy],
                  module: :restaurants
      end
      resources :shops,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit update show destroy],
                  module: :shops
      end
      resources :hotels,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit update show destroy],
                  module: :hotels
      end
      resources :activities,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit update show destroy],
                  module: :activities
      end
      resources :hot_springs,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit update show destroy],
                  module: :hot_springs
      end
      resources :ski_areas,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit update show destroy],
                  module: :ski_areas
      end
      resources :photo_spots,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit update show destroy],
                  module: :photo_spots
      end
    end
  end

  resources :users,
            param: :public_uid,
            only: %i[index edit update show destroy] do
  end

  resources :organization_registrations, only: %i[index show] do
    resources :organization_registration_statuses, only: %i[create]
  end

  resources :announcements
end
