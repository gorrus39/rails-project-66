# frozen_string_literal: true

class GithubClient
  def initialize(access_token)
    @client = Octokit::Client.new(access_token:, auto_paginate: true)
  end

  def repos
    @client.repos
  end

  def repos_collection(user)
    repos = repos_with_valid_lang(@client.repos, user)
    repos.map! { |rep| [rep[:full_name], rep[:id]] }
    repos.each { |rep| ::Repository.create(github_id: rep[1], full_name: rep[0]) }
    repos
  end

  def get_latest_commit_sha(rep_full_name)
    @client.commits(rep_full_name).first.sha
  end

  def create_hook(repository)
    @client.create_hook(
      repository.full_name,
      'web',
      { url: "#{ENV.fetch('BASE_URL', nil)}/api/checks", content_type: 'json' },
      { events: %w[push], active: true }
    )
  end

  def clone_repository(repository, dir_path)
    system("git clone #{repository.clone_url} #{dir_path}")
  end

  def find_instance_repository(github_id)
    repos.find { |rep| rep[:id] == github_id&.to_i }
  end

  def repository_params(github_repo_id)
    current_repo = user_repositories.find { |repo| repo[:id] == github_repo_id.to_i }
    {
      name: current_repo[:name],
      full_name: current_repo[:full_name],
      language: current_repo[:language].downcase,
      clone_url: current_repo[:clone_url],
      ssh_url: current_repo[:ssh_url],
      github_id: github_repo_id.to_i
    }
  end

  private

  def user_repositories
    @client.repos
  end

  def repos_with_valid_lang(repos, user)
    repos.filter do |rep|
      next false unless rep[:language]

      language = rep[:language].downcase
      repo = user.repositories.new(language:)
      repo.github_id = rep[:id]
      repo.valid?
    end
  end
end
