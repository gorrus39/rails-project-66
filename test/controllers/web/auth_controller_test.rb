require "test_helper"

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get web_auth_new_url
    assert_response :success
  end

  test "should get create" do
    get web_auth_create_url
    assert_response :success
  end
end
