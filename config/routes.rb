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
        collection do
          get :beauticians
        end
        member do
          resource :settings_beauticians, only: [:show]
        end
      end
      resources :services, only: [:index]
      resources :favorites, only: [:index, :create, :destroy]
      resources :addresses, only: [:update]
      resources :availabilities, only: [:update]
      resources :languages, only: [:index]
      resources :pictures, only: [:index, :show, :create, :destroy]
    end
  end
end
