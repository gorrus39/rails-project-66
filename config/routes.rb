# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post 'checks', to: 'checks#from_webhook'
  end
  scope module: :web do
    root 'home#index'

    resources :repositories, only: %i[index show new create update] do
      post :checks, on: :member
      resources :checks, only: %i[show]
    end
    # get '/repositories/:repository_id/checks/:id', as: :repository_checks, to: 'checks#show'

    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    post 'auth/log_out', to: 'auth#log_out', as: :auth_log_out
    post 'auth/:provider', to: 'auth#request', as: :auth_request
  end
end
