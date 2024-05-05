# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(user_id, check_id)
    user = User.find(user_id)
    check = ::Repository::Check.find(check_id)
    check.run_check!
    lintering user, check
  end

  private

  def lintering(user, check)
    linter_result_json = check_exec(user, check)

    if (linter_result_json[:offense_count]).positive?
      check.fail!
      check.update(details: linter_result_json)
      # CheckResultMailer.with(email: user.email).failed_check_email.deliver_later
    else
      check.passed = true
      check.finish!
      # CheckResultMailer.with(email: user.email).passed_check_email.deliver_later
    end
  end

  def check_exec(user, check)
    repository = check.repository
    github_client = github_client_by(user)
    check.commit_id = github_client.get_latest_commit_sha(repository.full_name)

    dir_path = Rails.root.join("tmp/clone_app/#{repository.id}")
    FileUtils.rm_rf dir_path
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
