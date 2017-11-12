require 'test_helper'

class JoggingLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jogging_log = jogging_logs(:one)
  end

  test "should get index" do
    get jogging_logs_url, as: :json
    assert_response :success
  end

  test "should create jogging_log" do
    assert_difference('JoggingLog.count') do
      post jogging_logs_url, params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show jogging_log" do
    get jogging_log_url(@jogging_log), as: :json
    assert_response :success
  end

  test "should update jogging_log" do
    patch jogging_log_url(@jogging_log), params: { jogging_log: { date: @jogging_log.date, distance: @jogging_log.distance, duration: @jogging_log.duration, user_id: @jogging_log.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy jogging_log" do
    assert_difference('JoggingLog.count', -1) do
      delete jogging_log_url(@jogging_log), as: :json
    end

    assert_response 204
  end
end
