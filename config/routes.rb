Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :get_tasks, only: [:create]
    resources :complete_tasks, only: [:create]
    resources :oauth_tokens, only: [:create]
  end
end
