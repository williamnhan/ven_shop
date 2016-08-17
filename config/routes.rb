Rails.application.routes.draw do
  #root 	 'static_page#home'
  root   'products#index'
  get  	 '/help', 	 to: 'static_page#help'
  #get   '/about',   to: 'static_page#about'
  #get   '/contact', to: 'static_page#contact'
  get  	 '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users

  resources :products, only: [:index]
  resource  :cart, only: [:show]
  resources :order_items, only: [:create, :update, :destroy]
end
