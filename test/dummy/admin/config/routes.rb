Admin::Engine.routes.draw do
  resources :articles
  root to: "application#welcome"
end
