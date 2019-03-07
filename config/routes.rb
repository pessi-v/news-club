Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}
  root to: 'articles#index'
  # root to: 'pages#home'
  resources :subscriptions, only: [:new, :create] do
    resources :payments, only: [:new, :create]
  end
  resources :articles, only: [:index, :show]
  resources :preferences, only: [:index, :update]
end
