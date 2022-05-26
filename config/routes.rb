Rails.application.routes.draw do
  root 'pages#home'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  namespace :mypage do
    get 'profile', to: 'users#show'
    patch 'profile', to: 'users#update'
    delete 'profile', to: 'users#destroy'
    get 'profile/edit', to: 'users#edit'
  end
end
