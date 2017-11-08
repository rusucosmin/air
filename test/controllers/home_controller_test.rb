require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  def authenticated_as_header(user)
    token = Knock::AuthToken.new(payload: {sub: user.id}).token
    {'Authorization': "Beared #{token}"}
  end

  test "home page should be public" do
    get "/"
    assert_response :success
  end

  test "auth page should return unauthroized" do
    get "/auth"
    assert_response :unauthorized
  end

  test "auth page should return success for normal user" do
    get "/auth",
        headers: authenticated_as_header(users(:one))
    assert_response :success
  end

  test "auth page should return success for manager user" do
    get "/auth",
        headers: authenticated_as_header(users(:manager))
    assert_response :success
  end

  test "auth page should return success for admin user" do
    get "/auth",
        headers: authenticated_as_header(users(:admin))
    assert_response :success
  end
end
