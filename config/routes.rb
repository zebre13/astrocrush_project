Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions", confirmations: "users/confirmations"}
  devise_scope :user do
    get 'onboarding_birth', to: 'devise/registrations#onboarding_birth'
    get 'onboarding_profil', to: 'devise/registrations#onboarding_profil'
    get 'edit_password', to: 'devise/registrations#edit_password'
    get 'edit_infos', to: 'devise/registrations#edit_infos'
  end

  root to: 'users#index'
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :matches
  # get 'current_user', to: 'users#current_user'
  get 'dashboard', to: 'users#dashboard'
  get 'astroboard', to: 'users#astroboard'
  post '/create_denied_match', to: 'matches#create_denied_match', as: 'create_denied_match'
  # get '/users/:id', to: 'users#show'
  resources :users, only: %i[show]
  # get 'test', to: "users#test"
end
