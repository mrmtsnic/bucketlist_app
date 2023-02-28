Rails.application.routes.draw do
  root "static_pages#home" 
  get "/signup", to: "users#new"
  get "/login",  to: "sessions#new"
  post "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :list_items, only: [:create, :edit, :destroy, :update] do
    resources :likes, only: [:create, :destroy]
    member do
      post 'accomplish'
    end
  end
end
