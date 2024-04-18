# frozen_string_literal: true

module Web
  class HomeController < Web::ApplicationController
    def index
      # UserMailer.with(subject: '@user').welcome_email.deliver_now
    end
  end
end
