Rails.application.routes.draw do
  devise_for :users #, :controllers => {:registrations => "registrations"}
  root to: 'users#index'
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :matches
  get 'dashboard', to: 'users#dashboard'
  get 'astroboard', to: 'users#astroboard'
  post '/create_denied_match', to: 'matches#create_denied_match', as: 'create_denied_match'
  # get '/users/:id', to: 'users#show'
  resources :users, only: [:show, :edit]
  get 'test', to: "users#test"
end
