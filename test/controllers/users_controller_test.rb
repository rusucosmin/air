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
    assert_equal User.all.length, users.length
  end

  test "/users should return a list of all users for logged admin" do
    get "/users",
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    users = JSON.parse(response.body)
    assert_equal User.all.length, users.length
  end

  test "normal user creation should be public" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" } },
        headers: authenticated_as_header(users(:one))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_equal now + 1, User.all.length
  end

  test "normal user should not be able to create managers" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd",
              role: "manager" } },
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
  end

  test "normal user should not be able to create admins" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd",
              role: "admin" } },
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
  end

  test "manager should be able to create users" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" } },
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_equal now + 1, User.all.length
  end

  test "managers should be able to create managers" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "manager" }},
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "manager", user["role"]
    assert_equal now + 1, User.all.length
  end

  test "managers should not be able to create admins" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "admin" }},
        headers: authenticated_as_header(users(:manager))
    assert_response :unauthorized
    assert_equal now, User.all.length
  end

  test "admin should be able to create users" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" } },
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_equal now + 1, User.all.length
  end

  test "admin should be able to create managers" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "manager" }},
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "manager", user["role"]
    assert_equal now + 1, User.all.length
  end

  test "admins should be able to create admins" do
    now = User.all.length
    post "/user",
        params: { user: { email: "new@example.com", password: "strongpasswd" ,
        role: "admin" }},
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "new@example.com", user["email"]
    assert_equal "admin", user["role"]
    assert_equal now + 1, User.all.length
  end

  test "current user should return unauthorised for unlogged user" do
    get "/user/current"
    assert_response :unauthorized
  end

  test "users should be able to get their profile" do
    get "/user/current",
        headers: authenticated_as_header(users(:one))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "one@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
  end

  test "managers should be able to get their profile" do
    get "/user/current",
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "manager@example.com", user["email"]
    assert_equal "manager", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
  end

  test "admins should be able to get their profile" do
    get "/user/current",
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    user = JSON.parse(response.body)
    assert_equal "admin@example.com", user["email"]
    assert_equal "admin", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
  end

  test "user update should be non-public" do
    user = User.find_by_id(1)
    patch "/user/1",
        params: { user: { email: "two@example.com", password: "_a_strong_passwd" } }
    assert_response :unauthorized
    assert_equal user, User.find_by_id(1)
  end

  test "user should be able to update its own profile" do
    patch "/user/1",
        params: { user: { email: "1@example.com", password: "_password_one"}},
        headers: authenticated_as_header(users(:one))
    assert_response :success
    # first, assert the returned values
    user = JSON.parse(response.body)
    assert_equal "1@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
    # second, assert the things in database
    dbuser = User.find_by_id(1)
    assert_equal "1@example.com", dbuser.email
    assert_equal "user", dbuser.role
  end

  test "user should not be able to update its profile with an already taked email" do
    now = User.all.length
    user = User.find_by_id(1)
    patch "/user/1",
        params: { user: { email: "two@example.com", password: "_password_one"}},
        headers: authenticated_as_header(users(:one))
    assert_response :bad_request
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(1)
  end

  test "user should not be able to update somebody else's profile" do
    now = User.all.length
    user = User.find_by_id(2)
    patch "/user/2",
        params: { user: { email: "three@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(2)
  end

  test "user should not be able to update managers profile" do
    now = User.all.length
    user = User.find_by_id(3)
    patch "/user/3",
        params: { user: { email: "three@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(3)
  end

  test "user should not be able to update admins profile" do
    now = User.all.length
    user = User.find_by_id(4)
    patch "/user/4",
        params: { user: { email: "three@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(4)
  end

  test "manager should be able to update users profile" do
    now = User.all.length
    user = User.find_by_id(2)
    patch "/user/2",
        params: { user: { email: "three@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    assert_equal now, User.all.length
    # assert the json response
    user = JSON.parse(response.body)
    assert_equal "three@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
    # asert the database persistance
    user = User.find_by_id(2)
    assert_equal "three@example.com", user.email
    assert_equal "user", user.role
  end

  test "manager should not be able to update other managers profile" do
    now = User.all.length
    user = User.find_by_id(5)
    patch "/user/5",
        params: { user: { email: "managertwo@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:manager))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(5)
  end

  test "manager should not be able to update other admins profile" do
    now = User.all.length
    user = User.find_by_id(4)
    patch "/user/4",
        params: { user: { email: "managertwo@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:manager))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(4)
  end

  test "admin should be able to update users profile" do
    now = User.all.length
    user = User.find_by_id(2)
    patch "/user/2",
        params: { user: { email: "three@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    assert_equal now, User.all.length
    # json
    user = JSON.parse(response.body)
    assert_equal "three@example.com", user["email"]
    assert_equal "user", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
    # db
    user = User.find_by_id(2)
    assert_equal "three@example.com", user.email
    assert_equal "user", user.role
  end

  test "admin should be able to update other managers profile" do
    now = User.all.length
    user = User.find_by_id(5)
    patch "/user/5",
        params: { user: { email: "managertwo@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    assert_equal now, User.all.length
    # JSON
    user = JSON.parse(response.body)
    assert_equal "managertwo@example.com", user["email"]
    assert_equal "manager", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
    # db
    user = User.find_by_id(5)
    assert_equal "managertwo@example.com", user.email
    assert_equal "manager", user.role
  end

  test "admin should be able to update other admins profile" do
    now = User.all.length
    user = User.find_by_id(6)
    patch "/user/6",
        params: { user: { email: "admintwo@example.com", password: "_password_three"}},
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    assert_equal now, User.all.length
    # JSON
    user = JSON.parse(response.body)
    assert_equal "admintwo@example.com", user["email"]
    assert_equal "admin", user["role"]
    assert_not_nil user["created_at"]
    assert_not_nil user["updated_at"]
    # db
    user = User.find_by_id(6)
    assert_equal "admintwo@example.com", user.email
    assert_equal "admin", user.role
  end

  test "return bad_request if user not found" do
    now = User.all.length
    delete "/user/7",
        headers: authenticated_as_header(users(:admin))
    assert_response :bad_request
    assert_equal now, User.all.length
    assert_nil User.find_by_id(7)
  end

  test "user should be able to delete its account" do
    now = User.all.length
    delete "/user/1",
        headers: authenticated_as_header(users(:one))
    assert_response :success
    assert_equal now - 1, User.all.length
    assert_nil User.find_by_id(1)
  end

  test "user should not be able to delete other user accounts" do
    now = User.all.length
    user = User.find_by_id(2)
    delete "/user/2",
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(2)
  end

  test "user should not be able to delete manager accounts" do
    now = User.all.length
    user = User.find_by_id(3)
    delete "/user/3",
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(3)
  end

  test "user should not be able to delete admin accounts" do
    now = User.all.length
    user = User.find_by_id(4)
    delete "/user/4",
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(4)
  end

  test "manger should be able to delete other user accounts" do
    now = User.all.length
    delete "/user/2",
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    assert_equal now - 1, User.all.length
    assert_nil User.find_by_id(2)
  end

  test "manager should be able to delete manager accounts" do
    now = User.all.length
    delete "/user/3",
        headers: authenticated_as_header(users(:manager))
    assert_response :success
    assert_equal now - 1, User.all.length
    assert_nil User.find_by_id(3)
  end


  test "manager should not be able to delete admin accounts" do
    now = User.all.length
    user = User.find_by_id(4)
    delete "/user/4",
        headers: authenticated_as_header(users(:manager))
    assert_response :unauthorized
    assert_equal now, User.all.length
    assert_equal user, User.find_by_id(4)
  end

  test "admin should be able to delete other user accounts" do
    now = User.all.length
    delete "/user/2",
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    assert_equal now - 1, User.all.length
    assert_nil User.find_by_id(2)
  end

  test "admin should be able to delete manager accounts" do
    now = User.all.length
    delete "/user/3",
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    assert_equal now - 1, User.all.length
    assert_nil User.find_by_id(3)
  end

  test "admin should be able to delete admin accounts" do
    now = User.all.length
    delete "/user/6",
        headers: authenticated_as_header(users(:admin))
    assert_response :success
    assert_equal now - 1, User.all.length
    assert_nil User.find_by_id(6)
  end

  test "users should not be able to upgrade themselves to admin" do
    patch "/user/1",
        headers: authenticated_as_header(users(:one)),
        params: { user: { role: "admin"}}
    assert_response :unauthorized
    assert_equal User.find(1).role, "user"
  end

  test "users should not be able to upgrade themselves to managers" do
    patch "/user/1",
        params: { user: { role: "manager"}},
        headers: authenticated_as_header(users(:one))
    assert_response :unauthorized
    assert_equal User.find(1).role, "user"
  end

  test "mangers should not be able to upgrade themselves to admins" do
    patch "/user/3",
        params: { user: { role: "admin"}},
        headers: authenticated_as_header(users(:manager))
    assert_response :unauthorized
    assert_equal User.find(3).role, "manager"
  end
end
