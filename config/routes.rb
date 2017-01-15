Rails.application.routes.draw do
  get 'sessions/new'

  root   'static_pages#home'

  get    '/profile',        to: 'users#show'
  get    '/signup',         to: 'users#new'
  post   '/signup',         to: 'users#create'
  get    '/settings',       to: 'users#edit'
  post   '/settings',       to: 'users#update'
  get    '/login',          to: 'sessions#new'
  post   '/login',          to: 'sessions#create'
  delete '/logout',         to: 'sessions#destroy'
  post   '/new',            to: 'entries#create'
  get    '/edit',           to: 'entries#edit'
  post   '/edit',           to: 'entries#update'
  post   '/destroy',        to: 'entries#destroy'
  get    '/sort',           to: 'entries#sort'
  resources :users, only: [:create, :destroy, :edit, :update]
  resources :entries, only: [:create, :destroy, :edit, :show, :update, :sort]
end
