Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json } do
    scope moudle: :v1 do
    end
  end
  root to: 'home#index'
end
