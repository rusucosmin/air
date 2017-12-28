require 'test_helper'

class BuyListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @buy_list = buy_lists(:one)
  end

  test "should get index" do
    get buy_lists_url, as: :json
    assert_response :success
  end

  test "should create buy_list" do
    assert_difference('BuyList.count') do
      post buy_lists_url, params: { buy_list: { description: @buy_list.description, name: @buy_list.name, user_id: @buy_list.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show buy_list" do
    get buy_list_url(@buy_list), as: :json
    assert_response :success
  end

  test "should update buy_list" do
    patch buy_list_url(@buy_list), params: { buy_list: { description: @buy_list.description, name: @buy_list.name, user_id: @buy_list.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy buy_list" do
    assert_difference('BuyList.count', -1) do
      delete buy_list_url(@buy_list), as: :json
    end

    assert_response 204
  end
end
