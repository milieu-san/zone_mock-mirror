Rails.application.routes.draw do

  namespace :api, { format: :json } do
    namespace :v1 do
      get '/my', to: 'my#show'
      resources :users, only: [:index] do
        collection do
          post :onetime_token
        end
      end

      resource :friendships, only: [:create, :destroy]

      namespace :users do
        resources :rooms, only: [:index, :create, :destroy] do
          resource :subscriptions, only: [:create, :destroy]
        end
        resources :friends, only: [:index]
      end

      resources :rooms, only: :index

      mount_devise_token_auth_for 'User', at: 'auth'
      mount ActionCable.server => '/cable'
    end
  end
end
