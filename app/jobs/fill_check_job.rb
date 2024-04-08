# frozen_string_literal: true

require Rails.root.join('app/lib/linter_handler.rb').to_s

class FillCheckJob < ApplicationJob
  queue_as :default

  def perform(user, check)
    linter_result_json = check_exec(user, check)

    if (linter_result_json[:offense_count]).positive?
      check.to_fail!
      check.update(details: linter_result_json)
      NotifyMailer.with(subject: 'subject').notify_when_linter_failed.deliver_later
    else
      check.passed = true
      check.to_finished!
    end
  end

  private

  def check_exec(user, check)
    repository = check.repository
    github_client = github_client_by(user)
    check.commit_id = github_client.get_latest_commit_sha(repository.full_name)

    dir_path = Rails.root.join("tmp/clone_app/#{repository.id}")
    github_client.clone_repository(repository, dir_path)

    linter = LinterHandler.new(repository)

    result_json = linter.exec(dir_path)
    FileUtils.rm_rf(dir_path)
    result_json
  end

  def github_client_by(user)
    github_client_class = AppContainer.resolve(:github_client)
    @github_client = github_client_class.new(user.token)
  end
end
