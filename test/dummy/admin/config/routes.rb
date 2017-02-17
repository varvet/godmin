Admin::Engine.routes.draw do
  resources :articles
  resources :authorized_articles
  root to: "application#welcome"
end
