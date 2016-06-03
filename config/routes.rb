Rails.application.routes.draw do
  root 'home#index'
  use_doorkeeper
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
