# frozen_string_literal: true

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

  def get_latest_commit_sha(_rep_full_name)
    'random_hash commit_id'
  end

  def clone_repository(_repository, dir_path)
    FileUtils.mkdir_p(dir_path)
  end

  def find_instance_repository(github_id)
    Repository.find_by(github_id: github_id&.to_i)
  end

  def repos_collection(_user)
    [{ github_id: 2_154_678_232 },
     { github_id: 1_375_353_851 },
     { github_id: 3_121_192_416 },
     { github_id: 3_070_375_124 }]
  end

  def repository_params(github_repo_id)
    {
      name: 'javascript/repo',
      full_name: 'tovarish39/javascript_repo',
      language: 'javascript',
      clone_url: 'http://github.git/tovarish39/ruby_repo',
      github_id: github_repo_id,
      ssh_url: 'github.git/tovarish39/ruby_repo'
    }
  end
end
