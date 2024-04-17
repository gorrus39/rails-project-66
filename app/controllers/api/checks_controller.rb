# frozen_string_literal: true

module Api
  class ChecksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token
    def from_webhook
      Rails.logger.debug 'here'
    end
  end
end
