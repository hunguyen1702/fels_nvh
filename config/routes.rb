Rails.application.routes.draw do
  root "static_pages#home"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, except: :destroy do
    member do
      get :following, :followers
    end
  end
  resources :categories, only: :index
  resources :words, only: %i(index show)
  resources :lessons, except: %i(new edit)
  resources :account_activations, only: :edit
  resources :password_resets, except: %i(destroy show index)
  resources :relationships, only: %i(create destroy)
  resources :activities, only: :destroy

  namespace :admin do
    root "static_pages#home"
    resources :words, except: :show
    resources :categories, except: :show
    resources :users, only: %i(index destroy)
  end
end
