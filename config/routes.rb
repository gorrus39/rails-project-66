# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    get 'auth/:provider/callback', to: 'auth#callback'
    post 'auth/log_out', to: 'auth#log_out', as: 'auth_log_out'
    post 'auth/:provider', to: 'auth#request', as: 'auth_request'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
