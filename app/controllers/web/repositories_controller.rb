# frozen_string_literal: true

require Rails.root.join('app/lib/github_client').to_s

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

    def checks
      repository = Repository.find(params[:id])
      repsitory_check = repository.checks.create
      CheckingRepositoryJob.perform_later(repository, current_user, repsitory_check)
      redirect_to repository
    end

    def new
      @repository = Repository.new
      @repositories = @github_client.repos_collection(current_user)
    end

    def create
      repository = repository_instance
      if repository.save
        repsitory_check = repository.checks.create
        MountWebhookJob.perform_now(repository, current_user)
        CheckingRepositoryJob.perform_later(repository, current_user, repsitory_check)
        flash[:notice] = t('.notice')
      else
        flash[:alert] = t('.alert')
      end
      redirect_to repositories_path
    end

    private

    def repository_instance
      current_user.repositories.new(repository_params(rep_hash))
    end

    def set_github_client
      github_client_class = AppContainer.resolve(:github_client)
      @github_client = github_client_class.new(current_user.token)
    end

    def rep_hash
      @github_client.repos.find { |rep| rep[:id] == params[:repository][:id]&.to_i }
    end

    def repository_params(rep_hash)
      { clone_url: rep_hash[:clone_url],
        full_name: rep_hash[:full_name],
        language: rep_hash[:language]&.downcase&.to_sym,
        name: rep_hash[:name],
        ssh_url: rep_hash[:ssh_url],
        github_id: rep_hash[:id] }
    end
  end
end
