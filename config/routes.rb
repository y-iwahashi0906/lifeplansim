Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users
  resources :asset_sims, only: [:create, :update, :destroy]
  resources :events, only: [:new, :create, :update, :edit, :destroy ]
end