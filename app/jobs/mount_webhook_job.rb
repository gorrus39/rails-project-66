# frozen_string_literal: true

require Rails.root.join('app/lib/linter_handler.rb').to_s

class MountWebhookJob < ApplicationJob
  queue_as :default

  def perform(repository, user)
    github_client = github_client_by(user)
    github_client.mount_webhook(repository)
  end

  private

  def github_client_by(user)
    github_client_class = AppContainer.resolve(:github_client)
    github_client_class.new(user.token)
  end
end
