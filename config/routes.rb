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
      resource :credentials, only: [:show, :destroy], path: :me, me: true do
        collection do
          resource :settings_beauticians, only: [:show, :update]
          resources :pictures, only: [:index, :create]
        end
      end
      resources :users, only: [:index, :show] do
        member do
          resource :settings_beauticians, only: [:show]
          resources :availabilities, only: [:index]
        end
        collection do
          get :beauticians
        end
      end
      resources :services, only: [:index]
      resources :favorites, only: [:index, :create, :destroy]
      resources :addresses, only: [:update]
      resources :availabilities, only: [:update]
      resources :languages, only: [:index]
      resources :pictures, only: [:index, :show, :create, :destroy]
      resources :bookings, only: [:create, :show, :index] do
        resources :reviews, only: [:create]
        member do
          put :cancel
          put :accept
          put :reschedule
        end
        collection do
          get :last_unreviewed
        end
      end
      resources :payment_methods do
        collection do
          get :default
        end
        member do
          put :set_default
        end
      end
      resources :reviews, only: [:index, :show]
    end
  end
end
