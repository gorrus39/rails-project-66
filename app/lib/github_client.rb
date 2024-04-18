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
    repos.map { |rep| [rep[:full_name], rep[:id]] }
  end

  def get_latest_commit_sha(rep_full_name)
    @client.commits(rep_full_name).first.sha
  end

  def mount_webhook(repository)
    @client.create_hook(
      repository.full_name,
      'web',
      { url: "#{ENV.fetch('BASE_URL', nil)}/api/checks", content_type: 'json' },
      { events: %w[push], active: true }
    )
  end

  private

  def repos_with_valid_lang(repos, user)
    repos.filter do |rep|
      next false unless rep[:language]

      language = rep[:language].downcase.to_sym
      user.repositories.new(language:).valid?
    end
  end
end

class GithubClientStub
  def initialize(access_token)
    @client = Octokit::Client.new(access_token:, auto_paginate: true)
  end

  def repos
    [{
      id: 617_035_038,
      ssh_url: 'R_kgDOJMc1Hg',
      name: 'testmod',
      full_name: 'tovarish39/testmod',
      language: 'Ruby',
      clone_url: 'tovarish39/testmod'
    }]
  end
end
