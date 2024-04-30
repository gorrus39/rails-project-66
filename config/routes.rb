# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :checks, only: %i[create]
  end
  scope module: :web do
    root 'home#index'

    resources :repositories, only: %i[index show new create update] do
      resources :checks, only: %i[show create]
    end

    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    post 'auth/logout', to: 'auth#logout', as: :auth_logout
    post 'auth/:provider', to: 'auth#request', as: :auth_request
  end
end
