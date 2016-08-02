Rails.application.routes.draw do
  root 'static_page#home'
  get  '/help', to: 'static_page#help'
  #get  '/about',   to: 'static_pages#about'
  #get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  resource :users
end
