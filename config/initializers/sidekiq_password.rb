require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [
    Rails.application.credentials.dig(:basic_auth, :user),
    Rails.application.credentials.dig(:basic_auth, :password),
  ]
end
