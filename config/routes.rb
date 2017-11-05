Rails.application.routes.draw do
  root "static_pages#home"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, except: :destroy
  resources :categories, only: :index
  resources :words, only: %i(index show)
  resources :account_activations, only: :edit
  resources :password_resets, except: %i(destroy show index)

  namespace :admin do
    root "static_pages#home"
    resources :words
    resources :categories, except: :show
    resources :users, only: %i(index destroy)
  end
end
