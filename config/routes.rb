Rails.application.routes.draw do
  get "users/new"
  get "/about", to: "static_pages#about"
  get "/home", to: "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup",  to: "users#create"

  resources :users

  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static_pages#home"
end
