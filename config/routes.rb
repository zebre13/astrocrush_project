Rails.application.routes.draw do
  devise_for :users
  root to: 'users#index'
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :matches
<<<<<<< HEAD

  get 'dashboard', to:'pages#dashboard'

=======
  post '/create_denied_match', to: 'matches#create_denied_match', as: 'create_denied_match'
>>>>>>> 2ef264417b5245f075c7fa39f287b32d4edaeb76
  # get '/users/:id', to: 'users#show'
  resources :users, only: [:show, :edit]
end
