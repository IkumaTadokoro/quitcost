Rails.application.routes.draw do
  resources :insurances, only: %i(index new create edit update)
  namespace :api do
    resources :insurances, only: %i(index destroy)
  end
end
