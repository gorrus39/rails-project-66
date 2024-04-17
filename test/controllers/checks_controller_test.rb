require "test_helper"

class ChecksControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get checks_show_url
    assert_response :success
  end
end
