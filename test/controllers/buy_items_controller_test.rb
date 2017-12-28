require 'test_helper'

class BuyItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @buy_item = buy_items(:one)
  end

  test "should get index" do
    get buy_items_url, as: :json
    assert_response :success
  end

  test "should create buy_item" do
    assert_difference('BuyItem.count') do
      post buy_items_url, params: { buy_item: { buylist_id: @buy_item.buylist_id, description: @buy_item.description, name: @buy_item.name } }, as: :json
    end

    assert_response 201
  end

  test "should show buy_item" do
    get buy_item_url(@buy_item), as: :json
    assert_response :success
  end

  test "should update buy_item" do
    patch buy_item_url(@buy_item), params: { buy_item: { buylist_id: @buy_item.buylist_id, description: @buy_item.description, name: @buy_item.name } }, as: :json
    assert_response 200
  end

  test "should destroy buy_item" do
    assert_difference('BuyItem.count', -1) do
      delete buy_item_url(@buy_item), as: :json
    end

    assert_response 204
  end
end
