# frozen_string_literal: true

module Web
  class ChecksController < Web::ApplicationController
    def show
      @check = Repository::Check.includes(:repository).find(params[:id])
    end
  end
end
