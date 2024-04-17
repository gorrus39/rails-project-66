# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      data = request.env['omniauth.auth']
      user = get_user_by(data)

      session['user_id'] = user.id

      redirect_to root_path
    end

    def log_out
      session.delete('user_id')

      redirect_to root_path
    end

    private

    def get_user_by(data)
      email = data['info']['email']
      token = data['credentials']['token']
      nickname = data['info']['nickname']

      user = User.find_by(email:)
      if user
        user.update!(token:, nickname:)
      else
        user = User.create!(email:, token:, nickname:)
      end
      user
    end
  end
end
