# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    require Rails.root.join('app/lib/github_client').to_s

    before_action :autorize_user!
    before_action :set_github_client
    caches_action :new, expires_in: 5.minutes

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = Repository.new
      @repositories = @github_client.repos_collection(current_user)
    end

    def create
      repository = current_user.repositories.new(repository_params(rep_hash))

      if repository.save
        flash[:notice] = t('.notice')
      else
        flash[:alert] = t('.alert')
      end
      redirect_to repositories_path
    end

    private

    def set_github_client
      @github_client = GithubClient.new(current_user.token)
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
