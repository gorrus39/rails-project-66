# frozen_string_literal: true

module Web
  module RepositoriesHelper
    def github_commit_link(check)
      "https://github.com/#{check.repository.full_name}/commit/#{check.commit_id.slice(..6)}"
    end

    def github_file_path(file_path, check)
      "https://github.com/#{check.repository.full_name}/tree/#{check.commit_id.slice(..6)}/#{file_path}"
    end
  end
end
