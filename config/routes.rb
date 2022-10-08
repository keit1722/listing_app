require 'sidekiq/web'

Rails.application.routes.draw do
  root 'pages#home'
  get 'term', to: 'pages#term'
  get 'privacy', to: 'pages#privacy'
  get 'cookie', to: 'pages#cookie'
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
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
    collection { get 'search', controller: 'restaurants/search_forms' }
    resource :bookmarks, only: %i[create destroy], module: :restaurants
    resources :posts, only: %i[index show], module: :restaurants
  end
  resources :shops, param: :slug, only: %i[index show] do
    collection { get 'search', controller: 'shops/search_forms' }
    resource :bookmarks, only: %i[create destroy], module: :shops
    resources :posts, only: %i[index show], module: :shops
  end
  resources :hotels, param: :slug, only: %i[index show] do
    collection { get 'search', controller: 'hotels/search_forms' }
    resource :bookmarks, only: %i[create destroy], module: :hotels
    resources :posts, only: %i[index show], module: :hotels
  end

  resources :activities, param: :slug, only: %i[index show] do
    collection { get 'search', controller: 'activities/search_forms' }
    resource :bookmarks, only: %i[create destroy], module: :activities
    resources :posts, only: %i[index show], module: :activities
  end

  resources :hot_springs, param: :slug, only: %i[index show] do
    collection { get 'search', controller: 'hot_springs/search_forms' }
    resource :bookmarks, only: %i[create destroy], module: :hot_springs
    resources :posts, only: %i[index show], module: :hot_springs
  end
  resources :ski_areas, param: :slug, only: %i[index show] do
    collection { get 'search', controller: 'ski_areas/search_forms' }
    resource :bookmarks, only: %i[create destroy], module: :ski_areas
    resources :posts, only: %i[index show], module: :ski_areas
  end
  resources :photo_spots, param: :slug, only: %i[index show] do
    collection { get 'search', controller: 'photo_spots/search_forms' }
    resource :bookmarks, only: %i[create destroy], module: :photo_spots
    resources :posts, only: %i[index show], module: :photo_spots
  end
  resources :notices, only: [] do
    patch :read, on: :member
  end

  resources :organization_invitations, param: :token, only: %i[show] do
    member do
      patch :accepted, controller: 'organization_invitations/actions'
      patch :unaccepted, controller: 'organization_invitations/actions'
    end
  end

  resources :announcements, only: %i[index show]

  namespace :mypage do
    get 'profile', to: 'users#show'
    patch 'profile', to: 'users#update'
    delete 'profile', to: 'users#destroy'
    get 'profile/edit', to: 'users#edit'
    resources :bookmarks, only: %i[index]
    resources :notices, only: %i[index]
    resources :organization_registrations, only: %i[index show new create]

    get 'email_setting', to: 'incoming_emails#show'
    get 'email_setting/edit', to: 'incoming_emails#edit'
    patch 'email_setting', to: 'incoming_emails#update'
  end

  namespace :business do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
  end

  resources :organizations, param: :slug do
    scope module: :organizations do
      resources :organization_invitations, only: %i[index new create]
      resources :restaurants, param: :slug do
        resources :posts,
                  module: :restaurants,
                  only: %i[index show new edit destroy] do
          collection do
            post :publish
            post :unpublish
          end
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :shops, param: :slug do
        resources :posts,
                  module: :shops,
                  only: %i[index show new edit destroy] do
          collection do
            post :publish
            post :unpublish
          end
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :hotels, param: :slug do
        resources :posts,
                  module: :hotels,
                  only: %i[index show new edit destroy] do
          collection do
            post :publish
            post :unpublish
          end
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :activities, param: :slug do
        resources :posts,
                  module: :activities,
                  only: %i[index show new edit destroy] do
          collection do
            post :publish
            post :unpublish
          end
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :hot_springs, param: :slug do
        resources :posts,
                  module: :hot_springs,
                  only: %i[index show new edit destroy] do
          collection do
            post :publish
            post :unpublish
          end
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :ski_areas, param: :slug do
        resources :posts,
                  module: :ski_areas,
                  only: %i[index show new edit destroy] do
          collection do
            post :publish
            post :unpublish
          end
          member do
            patch :to_published
            patch :to_draft
            patch :as_published
            patch :as_draft
          end
        end
      end
      resources :photo_spots, param: :slug do
        resources :posts,
                  module: :photo_spots,
                  only: %i[index show new edit destroy] do
          collection do
            post :publish
            post :unpublish
          end
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

  resources :organization_users, param: :slug, only: %i[destroy]

  draw(:admin)

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
