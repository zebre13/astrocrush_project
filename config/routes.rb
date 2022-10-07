Rails.application.routes.draw do

  require "sidekiq/web"
  # Sidekiq jobs
  authenticate :user, ->(user) { user.admin? }do
    mount Sidekiq::Web => '/sidekiq/'
  end

  devise_for :users, controllers: { registrations: "users/registrations" }

  root to: 'users#index'
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :matches
  get 'current_user', to: 'users#current_user'
  get 'dashboard', to: 'users#dashboard'
  get 'astroboard', to: 'users#astroboard'
  post '/create_denied_match', to: 'matches#create_denied_match', as: 'create_denied_match'
  # get '/users/:id', to: 'users#show'
  resources :users, only: %i[show edit]
  get 'test', to: "users#test"
end
