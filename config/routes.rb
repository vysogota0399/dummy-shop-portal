Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :items
  resources :categories
  resources :orders
  resources :addresses
  resource :shopping_cart

  root "home#index"
end
