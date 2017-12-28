class BuyListsController < ApplicationController
  before_action :authenticate_user
  before_action :set_buy_list, only: [:show, :update, :destroy]

  # GET /buy_lists
  def index
    @buy_lists = current_user.buy_lists

    render json: @buy_lists
  end

  # GET /buy_lists/1
  def show
    render json: @buy_list
  end

  # POST /buy_lists
  def create
    @buy_list = BuyList.new(buy_list_params)

    if @buy_list.save
      render json: @buy_list, status: :created, location: @buy_list
    else
      render json: @buy_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /buy_lists/1
  def update
    if @buy_list.update(buy_list_params)
      render json: @buy_list
    else
      render json: @buy_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /buy_lists/1
  def destroy
    @buy_list.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buy_list
      @buy_list = BuyList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def buy_list_params
      params.require(:buy_list).permit(:name, :description, :user_id)
    end
end
