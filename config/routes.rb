Rails.application.routes.draw do
  root 'home#index'

  apipie
  use_doorkeeper
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :admin do
    resources :bookings do
      member do
        put :set_status
      end
    end
  end

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, path: 'v1' do
      devise_scope :user do
        post '/registrations' => 'registrations#create'
        put '/me' => 'credentials#update'
        resources :passwords, only: :create
      end
      get '/me' => 'credentials#show'
      delete '/me' => 'credentials#destroy'
      resources :users, only: [:show] do
        collection do
          get :beauticians
        end
      end
      resources :settings_beauticians, only: [:show] do
        collection do
          get :me
        end
      end
    end
  end
end
