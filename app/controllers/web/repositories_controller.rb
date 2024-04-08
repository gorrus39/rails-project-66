# frozen_string_literal: true

# require Rails.root.join('app/lib/github_client').to_s

module Web
  class RepositoriesController < Web::ApplicationController
    before_action :autorize_user!
    before_action :set_github_client
    caches_action :new, expires_in: 5.minutes

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
      repository = repository_instance
      if repository.save
        exec_actions_with(repository)
        flash[:notice] = t('.notice')
      else
        flash[:alert] = t('.alert')
      end
      redirect_to repositories_path
    end

    private

    def exec_actions_with(repository)
      check = repository.checks.create
      MountWebhookJob.perform_later(repository, current_user) if ENV['BASE_URL'].present?
      FillCheckJob.perform_later(current_user, check)
    end

    def repository_instance
      github_repo_id = params['repository']['github_id']
      rep_params = @github_client.repository_params(github_repo_id)
      current_user.repositories.new(rep_params)
    end

    def set_github_client
      github_client_class = AppContainer.resolve(:github_client)
      @github_client = github_client_class.new(current_user.token)
    end
  end
end
