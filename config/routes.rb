Rails.application.routes.draw do
  devise_for :users
  root to: 'users#index'
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :matches

  get 'dashboard', to:'pages#dashboard'

  # get '/users/:id', to: 'users#show'
  resources :users, only: [:show, :edit]
end
