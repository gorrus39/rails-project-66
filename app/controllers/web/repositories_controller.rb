# frozen_string_literal: true

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :authenticate_user!
    before_action :set_github_client

    def index
      @repositories = current_user.repositories.includes(:checks).order(created_at: :desc).page params[:page]
    end

    def show
      @repository = ::Repository.find(params[:id])
      authorize @repository
      @checks = @repository.checks.order(created_at: :desc).page params[:page]
    end

    def new
      @repository = current_user.repositories.build
      authorize @repository

      cache_key = "#{current_user.cache_key_with_version}/github_repositories"

      @repositories = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
        @github_client.repos_collection(current_user)
      end
    end

    def create
      repository = current_user.repositories.find_or_initialize_by(repository_params)
      authorize repository

      if repository.save
        UpdateInfoRepositoryJob.perform_later(repository.id, current_user.id)
        redirect_to repositories_path, notice: t('.create_success')
      else
        flash[:alert] = repository.errors.full_messages.join("\n")
        redirect_to action: :new
      end
    end

    private

    def repository_params
      @github_client.repository_params(params['repository']['github_id'])
    end

    def set_github_client
      github_client_class = AppContainer.resolve(:github_client)
      @github_client = github_client_class.new(current_user.token)
    end
  end
end
