Rails.application.routes.draw do
  resources :articles
  resources :secret_articles
  resource :session, only: [:new, :create, :destroy]
  root to: "application#welcome"
  mount Admin::Engine, at: "admin"
end
