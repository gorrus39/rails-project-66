# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      data = request.env['omniauth.auth']
      user = User.find_by(email: data['info']['email']) || create_user_by(data)

      session['user_id'] = user.id

      redirect_to root_path
    end

    def log_out
      session.delete('user_id')

      redirect_to root_path
    end

    private

    def create_user_by(data)
      email = data['info']['email']
      token = data['credentials']['token']
      nickname = data['info']['nickname']
      User.create!(email:, token:, nickname:)
    end
  end
end
