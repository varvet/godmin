Rails.application.routes.draw do
  resources :articles do
    resources :comments
  end
  resources :authenticated_articles
  resources :authorized_articles
  resource :session, only: [:new, :create, :destroy]

  resource :another_admin_session, only: [:create]

  root to: "application#welcome"
  mount Admin::Engine, at: "admin"
end
