# frozen_string_literal: true

module Web
  module Repository
    class ChecksController < Web::ApplicationController
      def show
        @check = ::Repository::Check.includes(:repository).find(params[:id])
        authorize @check
        if !@check.finished? && !@check.failed?
          flash[:notice] = t('.check_in_progress')
          redirect_to @check.repository
        else

          render :show
        end
      end

      def create
        repository = ::Repository.find(params[:repository_id])
        check = repository.checks.create!
        authorize check

        CheckRepositoryJob.perform_later(current_user.id, check.id)

        flash[:notice] = t('.create_success')
        redirect_to repository
      end
    end
  end
end
