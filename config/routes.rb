Rails.application.routes.draw do
  resources :insurances, only: [:index]
  namespace :api do
    resources :insurances, only: [:index]
  end
end
