# frozen_string_literal: true

# require Rails.root.join('app/lib/github_client').to_s

module Api
  class ChecksController < Api::ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      full_name = params[:repository][:full_name]
      repository = Repository.find_by(full_name:)

      unless repository
        head :not_found
        return
      end

      check = repository.checks.create!
      CheckRepositoryJob.perform_later(repository.user, check) if check
      head :ok
    end
  end
end
