Rails.application.routes.draw do
  resources :insurances, only: %i(index new create edit update)
  resources :pentions, only: %i(index)
  namespace :api do
    get 'pentions/index'
    resources :insurances, only: %i(index destroy)
    resources :pentions, only: %i(index)
  end
end
