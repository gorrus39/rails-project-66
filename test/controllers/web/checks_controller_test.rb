# frozen_string_literal: true

require 'test_helper'
# require Rails.root.join('app/lib/github_client').to_s

module Web
  class CheckControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @repository = repositories(:one)
    end

    test 'shold create check' do
      sign_in @user

      assert_difference('Repository::Check.count') do
        post repository_checks_url(@repository),
             params: { repository: { id: @repository.id, full_name: @repository.full_name } }
      end
    end
  end
end
