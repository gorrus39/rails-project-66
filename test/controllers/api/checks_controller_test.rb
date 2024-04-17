require "test_helper"

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test "should get from_webhook" do
    get api_checks_from_webhook_url
    assert_response :success
  end
end
