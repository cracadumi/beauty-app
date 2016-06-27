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
    match '*any' => 'api#options', via: [:options]
    scope module: :v1, path: 'v1' do
      devise_scope :user do
        resource :registrations, only: [:create]
        resource :credentials, only: [:update], path: :me
        resources :passwords, only: :create
      end
      resource :credentials, only: [:show, :destroy], path: :me do
        collection do
          resource :settings_beauticians, only: [:show, :update]
        end
      end
      resources :users, only: [:show] do
        collection do
          get :beauticians
        end
        member do
          resource :settings_beauticians, only: [:show]
        end
      end
      resources :addresses, only: [:update]
      resources :availabilities, only: [:update]
    end
  end
end
