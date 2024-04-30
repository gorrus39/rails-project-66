# frozen_string_literal: true

# require Rails.root.join('app/lib/github_client').to_s

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :autorize_user!
    before_action :set_github_client
    # caches_action :new, expires_in: 5.minutes

    def index
      @repositories = current_user.repositories.includes(:checks).order(created_at: :desc)
    end

    def show
      @repository = Repository.find(params[:id])
      @checks = @repository.checks.order(created_at: :desc)
    end

    def new
      @repository = Repository.new
      @repositories = @github_client.repos_collection(current_user)
    end

    def create
      github_repo_id = params['repository']['github_id']
      if github_repo_id.present?
        try_create_by(github_repo_id)
        redirect_to repositories_path
      else
        flash[:alert] = t('.alert')
        redirect_to new_repository_path
      end
    end

    private

    def try_create_by(github_repo_id)
      repository = repository_instance(github_repo_id)
      if repository.save
        exec_actions_with(repository)
        flash[:notice] = t('.notice')
      else
        flash[:alert] = t('.alert')
      end
    end

    def exec_actions_with(repository)
      check = repository.checks.create
      FillCheckJob.perform_later(current_user, check)
      MountWebhookJob.perform_later(repository, current_user) if ENV['BASE_URL'].present?
    end

    def repository_instance(github_repo_id)
      repository = Repository.find_by(github_id: github_repo_id)
      return repository if repository

      rep_params = @github_client.repository_params(github_repo_id)
      current_user.repositories.new(rep_params)
    end

    def set_github_client
      github_client_class = AppContainer.resolve(:github_client)
      @github_client = github_client_class.new(current_user.token)
    end
  end
end
