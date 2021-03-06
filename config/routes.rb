Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  authenticated do
    root to: 'admin/insurances#index', as: :authenticated_root
  end
  root to: 'home#index'

  namespace :admin do
    resources :insurances, only: %i(index new create edit update)
    resources :pensions, only: %i(index new create edit update)
    end
  namespace :api do
    resource :simulations, only: %i(show)
    namespace :admin do
      resources :insurances, only: %i(index destroy)
      resources :pensions, only: %i(index destroy)
    end
  end
  resources :home, only: %i(index)
  get 'privacy_policy', to: 'home#privacy_policy', as: 'privacy_policy'
  get 'tos', to: 'home#tos', as: 'tos'
  get '*path', to: 'home#index'
end
