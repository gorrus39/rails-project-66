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

  private

  def repos_with_valid_lang(repos, user)
    repos.filter do |rep|
      next false unless rep[:language]

      language = rep[:language].downcase.to_sym
      user.repositories.new(language:).valid?
    end
  end
end
