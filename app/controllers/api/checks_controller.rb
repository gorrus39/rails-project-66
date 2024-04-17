# frozen_string_literal: true

require Rails.root.join('app/lib/github_client').to_s

module Api
  class ChecksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token
    def from_webhook
      repository = Repository.find_by(full_name: request[:repository][:full_name])
      repsitory_check = repository.checks.create

      CheckingRepositoryJob.perform_later(repository, repository.user, repsitory_check)
      head :ok
    end
  end
end
