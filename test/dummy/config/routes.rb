Rails.application.routes.draw do
  resources :articles
  root to: "application#welcome"
  mount Admin::Engine, at: "admin"
end
