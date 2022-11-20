Rails.application.routes.draw do

  require "sidekiq/web"
  # Sidekiq jobs
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq/'
  end
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions", confirmations: "users/confirmations" }
  root to: 'users#index'
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  # Matches
  resources :matches
  post '/create_denied_match', to: 'matches#create_denied_match', as: 'create_denied_match'

  # After Sign Up
  resources :after_signup

  # Users
  resources :users
  get 'dashboard', to: 'users#dashboard'
  get 'astroboard', to: 'users#astroboard'
  get 'birth_date', to: 'users#birth_date'
  get 'edit_password', to: 'users#edit_password'
  get 'edit_infos', to: 'users#edit_infos'
  put 'update_user', to: 'users#update', as: 'update_user'
end
