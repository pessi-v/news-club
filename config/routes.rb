Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}
  root to: 'pages#home'
  resources :subscriptions, only: [:new, :create] do
    resources :payments, only: [:new, :create]
  end
end
