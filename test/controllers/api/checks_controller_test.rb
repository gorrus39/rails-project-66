# frozen_string_literal: true

require 'test_helper'

module Api
  class ChecksControllerTest < ActionDispatch::IntegrationTest
    test 'should get from_webhook' do
      get api_checks_from_webhook_url
      assert_response :success
    end
  end
end
