Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions", confirmations: "users/confirmations"}

  #Chatroom
  root to: 'users#index'
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  # Matches
  resources :matches
  post '/create_denied_match', to: 'matches#create_denied_match', as: 'create_denied_match'

  # Users
  resources :users, only: %i[show]
  get 'dashboard', to: 'users#dashboard'
  get 'astroboard', to: 'users#astroboard'
  get 'onboarding_birth', to: 'users#onboarding_birth'
  get 'onboarding_profil', to: 'users#onboarding_profil'
  get 'edit_password', to: 'users#edit_password'
  get 'edit_infos', to: 'users#edit_infos'
  put 'update-user', to: 'users#update', as: 'update_user'
end
