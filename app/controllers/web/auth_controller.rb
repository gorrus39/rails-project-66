# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      data = request.env['omniauth.auth']
      user = get_user_by(data)

      if user.save
        session['user_id'] = user.id
        flash[:notice] = t('.notice')
      else
        flash[:alert] = t('.alert')
      end

      redirect_to root_path
    end

    def logout
      session.delete('user_id')

      flash[:notice] = t('.notice')
      redirect_to root_path
    end

    private

    def get_user_by(data)
      email = data['info']['email']

      user = User.find_or_initialize_by(email:)

      user.token = data['credentials']['token']
      user.nickname = data['info']['nickname']
      user.provider = data['provider']
      user.provider_uid = data['uid']

      user
    end
  end
end
