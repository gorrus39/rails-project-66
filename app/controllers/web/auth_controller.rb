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
      provider = data['provider']
      provider_uid = data['uid']

      User.find_or_create_by(email:) do |user|
        user.update!(token:, nickname:, provider:, provider_uid:)
      end
    end
  end
end
