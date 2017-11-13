require 'test_helper'

class JoggingLogsControllerTest < ActionDispatch::IntegrationTest
  def authenticated_as_header(user)
    token = Knock::AuthToken.new(payload: {sub: user.id}).token
    {'Authorization': "Beared #{token}"}
  end

  setup do
    @jogging_log = jogging_logs(:one)
  end

  test "index should not be public" do
    get jogging_logs_url, as: :json
    assert_response :unauthorized
  end

  test "index admin should not be public" do
    get "/admin/jogging_logs", as: :json
    assert_response :unauthorized
  end

  test "should get joggings for current normal user" do
    jl = users(:one).jogging_logs
    get jogging_logs_url, as: :json, headers: authenticated_as_header(users(:one))
    assert_response :success
    assert_equal jl.length, JSON.parse(response.body).length
  end

  test "should get joggings for current admin user" do
    get jogging_logs_url, as: :json, headers: authenticated_as_header(users(:admin))
    assert_response :success
    resp = JSON.parse(response.body)
    assert_equal 0, resp.length
  end

  test "should get all joggings for admin" do
    sz = JoggingLog.all.length
    get "/admin/jogging_logs", as: :json, headers: authenticated_as_header(users(:admin))
    assert_response :success
    resp = JSON.parse(response.body)
    assert_equal sz, resp.length
  end

  test "create jogging_log should not be public" do
    assert_difference('JoggingLog.count', 0) do
      post jogging_logs_url, params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json
    end

    assert_response :unauthorized
  end

  test "should create jogging_log for current_user" do
    assert_difference('JoggingLog.count', 1) do
      post jogging_logs_url, params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json,
          headers: authenticated_as_header(users(:one))
    end

    assert_response 201
  end

  test "normal user should not be able to create jogging_logs for other users" do
    assert_difference('JoggingLog.count', 0) do
      post jogging_logs_url, params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json,
          headers: authenticated_as_header(users(:two))
    end

    assert_response :unauthorized
  end

  test "manager should not be able to create jogging_Logs for other users" do
    assert_difference('JoggingLog.count', 0) do
      post jogging_logs_url, params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json,
          headers: authenticated_as_header(users(:manager))
    end

    assert_response :unauthorized
  end

  test "admin should be able to create jogging_logs for to other users" do
    assert_difference('JoggingLog.count', 1) do
      post jogging_logs_url, params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json,
          headers: authenticated_as_header(users(:admin))
    end

    assert_response 201
  end

  test "show jogging_log should not be public" do
    get jogging_log_url(@jogging_log), as: :json
    assert_response :unauthorized
  end

  test "should show jogging_log for normal user" do
    get jogging_log_url(@jogging_log), as: :json,
        headers: authenticated_as_header(users(:one))

    assert_response :success
  end

  test "should show jogging_log for admin" do
    get jogging_log_url(@jogging_log), as: :json,
        headers: authenticated_as_header(users(:admin))

    assert_response :success
  end

  test "should not show jogging_log for manager" do
    get jogging_log_url(@jogging_log), as: :json,
        headers: authenticated_as_header(users(:manager))

    assert_response :unauthorized
  end

  test "update jogging_log should not be public" do
    patch jogging_log_url(@jogging_log), params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json
    assert_response :unauthorized
  end

  test "should update jogging_log for owner" do
    patch jogging_log_url(@jogging_log), params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json,
        headers: authenticated_as_header(users(:one))
    assert_response 200
  end

  test "should update jogging_log for admin" do
    patch jogging_log_url(@jogging_log), params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json,
        headers: authenticated_as_header(users(:admin))
    assert_response 200
  end

  test "should update jogging_log for manger" do
    patch jogging_log_url(@jogging_log), params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json,
        headers: authenticated_as_header(users(:manager))
    assert_response :unauthorized
  end

  test "destroy jogging_log should not be public" do
    assert_difference('JoggingLog.count', 0) do
      delete jogging_log_url(@jogging_log), as: :json
    end
    assert_response :unauthorized
  end

  test "should destroy jogging_log for owner" do
    assert_difference('JoggingLog.count', -1) do
      delete jogging_log_url(@jogging_log), as: :json,
          headers: authenticated_as_header(users(:one))
    end

    assert_response 204
  end

  test "should destroy jogging_log for admin" do
    assert_difference('JoggingLog.count', -1) do
      delete jogging_log_url(@jogging_log), as: :json,
          headers: authenticated_as_header(users(:admin))
    end

    assert_response 204
  end

  test "should not destroy jogging_log for manager" do
    assert_difference('JoggingLog.count', 0) do
      delete jogging_log_url(@jogging_log), as: :json,
          headers: authenticated_as_header(users(:manager))
    end
    assert_response :unauthorized
  end
end
