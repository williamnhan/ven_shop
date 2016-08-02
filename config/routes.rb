Rails.application.routes.draw do
  get 'users/new'

  get 'static_page/home'
  get 'static_page/help'
  root 'static_page#home'
end
