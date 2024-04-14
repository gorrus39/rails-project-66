# frozen_string_literal: true

class AppContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register(:github_client) { GithubClientStub }
  else
    register(:github_client) { GithubClient }
  end
end
