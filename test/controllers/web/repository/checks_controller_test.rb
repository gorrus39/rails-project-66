# frozen_string_literal: true

require 'test_helper'

module Web
  module Repository
    class CheckControllerTest < ActionDispatch::IntegrationTest
      setup do
        @repository = repositories(:one)
        @check = repository_checks(:finished)
        sign_in users(:one)
      end

      test 'shold create check' do
        assert_difference('::Repository::Check.count') do
          post repository_checks_url(@repository),
               params: { repository: { id: @repository.id, full_name: @repository.full_name } }
        end
      end

      test 'shold show' do
        get repository_check_url(@repository.id, @check.id)

        assert_response :success
      end
    end
  end
end
