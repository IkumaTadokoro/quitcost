Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :insurances, only: %i(index new create edit update)
  resources :pensions, only: %i(index new create edit update)
  namespace :api do
    resource :simulations, only: %i(show)
    resources :insurances, only: %i(index destroy)
    resources :pensions, only: %i(index destroy)
  end
  get 'home/index'
  get '*path', to: 'home#index'
end
