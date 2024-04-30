# frozen_string_literal: true

module AuthManagement
  extend ActiveSupport::Concern
  included do
    helper_method :current_user

    def current_user
      @current_user ||= User.find_by(id: session['user_id'])
    end

    def authenticate_user!
      return if current_user

      flash[:alert] = t('.alert')
      redirect_to root_path
    end
  end
end
