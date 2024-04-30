# frozen_string_literal: true

module Web
  class ChecksController < Web::ApplicationController
    def show
      @check = Repository::Check.includes(:repository).find(params[:id])
      return unless !@check.finished? && !@check.failed?

      flash[:notice] = t('.notice')
    end

    def create
      repository = Repository.find(params[:repository_id])
      check = repository.checks.create!
      MountWebhookJob.perform_later(repository, current_user) if ENV['BASE_URL'].present?

      CheckRepositoryJob.perform_later(current_user, check)

      flash[:notice] = t('.notice')
      redirect_to repository
    end
  end
end
