# frozen_string_literal: true

require Rails.root.join('app/lib/linter_handler.rb').to_s

class UpdateInfoRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository_id, user_id)
    repository = Repository.find(repository_id)
    user = User.find(user_id)

    github_client = github_client_by(user)
    github_client.create_hook(repository)
  rescue StandardError
    'webhook already exist'
  end

  private

  def github_client_by(user)
    github_client_class = AppContainer.resolve(:github_client)
    github_client_class.new(user.token)
  end
end
