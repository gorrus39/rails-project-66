# frozen_string_literal: true

require Rails.root.join('app/lib/linter_handler.rb').to_s

class CheckingRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository, user, repsitory_check)
    linter_result_json = check_exec(repository, user, repsitory_check)

    if (linter_result_json[:offense_count]).positive?
      repsitory_check.to_fail!
      repsitory_check.update(details: linter_result_json)
    else
      repsitory_check.to_success!
    end
  end

  private

  def check_exec(repository, user, repsitory_check)
    github_client = github_client_by(user)
    repsitory_check.commit_id = github_client.get_latest_commit_sha(repository.full_name)

    dir_path = Rails.root.join("tmp/clone_app/#{repsitory_check.id}")
    clone_repository(repository, dir_path)

    linter = LinterHandler.new(repository)

    result_json = linter.exec(dir_path)
    FileUtils.rm_rf(dir_path)
    result_json
  end

  def github_client_by(user)
    github_client_class = AppContainer.resolve(:github_client)
    @github_client = github_client_class.new(user.token)
  end

  def clone_repository(repository, dir_path)
    system("git clone #{repository.clone_url} #{dir_path}")
  end
end
