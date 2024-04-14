# frozen_string_literal: true

require 'test_helper'
# require Rails.root.join('app/lib/github_client').to_s

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @git_rep_id = 617_035_038
      # @repositories = [{
      #   id: @git_rep_id,
      #   ssh_url: 'R_kgDOJMc1Hg',
      #   name: 'testmod',
      #   full_name: 'tovarish39/testmod',
      #   language: 'Ruby',
      #   clone_url: 'tovarish39/testmod'
      # }]
    end

    test 'should get index page' do
      sign_in @user
      get repositories_url
      assert :success
    end

    test 'should NOT get index page' do
      get repositories_url
      assert_redirected_to root_path
    end

    test 'shold create repository' do
      sign_in @user

      # stub_request(:get, 'https://api.github.com/user/repos?per_page=100')
      #   .to_return_json(body: @repositories)

      post repositories_url, params: { repository: { id: @git_rep_id } }

      assert Repository.find_by(github_id: @git_rep_id)
    end
  end
end
