# frozen_string_literal: true

module Web
  class ChecksController < Web::ApplicationController
    def show
      @check = RepositoryCheck.includes(:repository).find(params[:id])
    end
  end
end
