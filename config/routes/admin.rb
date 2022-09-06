namespace :pvsuwimvsuoitmucvyku do
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
                  only: %i[index edit show destroy],
                  module: :restaurants do
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :shops,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts, only: %i[index edit show destroy], module: :shops do
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :hotels,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts, only: %i[index edit show destroy], module: :hotels do
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :activities,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit show destroy],
                  module: :activities do
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :hot_springs,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit show destroy],
                  module: :hot_springs do
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :ski_areas,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit show destroy],
                  module: :ski_areas do
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :photo_spots,
                param: :slug,
                only: %i[index edit update show destroy] do
        resources :posts,
                  only: %i[index edit show destroy],
                  module: :photo_spots do
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
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
