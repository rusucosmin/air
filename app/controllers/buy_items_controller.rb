class BuyItemsController < ApplicationController
  before_action :authenticate_user
  before_action :set_buy_item, only: [:show, :update, :destroy]

  # GET /buy_items
  def index
    @buy_items = BuyItem.all

    render json: @buy_items
  end

  # GET /buy_items/1
  def show
    render json: @buy_item
  end

  # POST /buy_items
  def create
    @buy_item = BuyItem.new(buy_item_params)

    if @buy_item.save
      render json: @buy_item, status: :created, location: @buy_item
    else
      render json: @buy_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /buy_items/1
  def update
    if @buy_item.update(buy_item_params)
      render json: @buy_item
    else
      render json: @buy_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /buy_items/1
  def destroy
    @buy_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buy_item
      @buy_item = BuyItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def buy_item_params
      params.require(:buy_item).permit(:name, :description, :buylist_id)
    end
end
