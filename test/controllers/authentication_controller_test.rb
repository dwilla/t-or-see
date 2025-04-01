require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get auth_path
    assert_response :success
  end
end
