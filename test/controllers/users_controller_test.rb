require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def authenticated_as_header(user)
    token = Knock::AuthToken.new(payload: {sub: user.id}).token
    {'Authorization': "Beared #{token}"}
  end

  test "/users should unauthorize logged out user" do
    get "/users"
    assert_response :unauthorized
  end

  test "/users should unauthorize normal user" do
    get "/users",
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
  end

  test "/users should return a list of all users for logged manager" do
    get "/users",
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    users = JSON.parse(response.body)
    assert_equal 4, users.length
  end

  test "/users should return a list of all users for logged admin" do
    get "/users",
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    users = JSON.parse(response.body)
    assert_equal 4, users.length
  end

  test "normal user creation should be public" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" } },
        headers: authenticated_as_header(users(:one))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_equal 5, User.all.length
  end

  test "normal user should not be able to create managers" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd",
              role: "manager" } },
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
  end

  test "normal user should not be able to create admins" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd",
              role: "admin" } },
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
  end

  test "manager should be able to create users" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" } },
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_equal 5, User.all.length
  end

  test "managers should be able to create managers" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "manager" }},
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "manager", user["role"]
    assert_equal 5, User.all.length
  end

  test "managers should not be able to create admins" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "admin" }},
        headers: authenticated_as_header(users(:manager))
    assert_response :unauthorized
  end

  test "admin should be able to create users" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" } },
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_equal 5, User.all.length
  end

  test "admin should be able to create managers" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "manager" }},
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "manager", user["role"]
    assert_equal 5, User.all.length
  end

  test "admins should be able to create admins" do
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "admin" }},
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "admin", user["role"]
    assert_equal 5, User.all.length
  end
end
