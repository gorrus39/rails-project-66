# frozen_string_literal: true

require 'test_helper'

module Web
  class HomeControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      get web_home_index_url
      assert_response :success
    end
  end
end
