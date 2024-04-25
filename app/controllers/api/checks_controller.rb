# frozen_string_literal: true

# require Rails.root.join('app/lib/github_client').to_s

module Api
  class ChecksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token
    def from_webhook
      repository = Repository.find_by(full_name: params[:repository][:full_name])
      check = repository&.checks&.create
      FillCheckJob.perform_later(repository.user, check) if check
      head :ok
    end
  end
end
