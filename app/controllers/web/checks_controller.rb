# frozen_string_literal: true

module Web
  class ChecksController < Web::ApplicationController
    def show
      @check = Repository::Check.includes(:repository).find(params[:id])
    end

    def create
      repository = Repository.find(params[:repository_id])
      check = repository.checks.create
      FillCheckJob.perform_later(current_user, check)
      redirect_to repository
    end
  end
end
