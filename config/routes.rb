Rails.application.routes.draw do
  devise_for :users
<<<<<<< HEAD
  root to: 'pages#home'
  resources :chatrooms, only: :show
=======
  root to: 'users#index'
>>>>>>> master
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :matches
end
