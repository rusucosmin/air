class JoggingLogsController < ApplicationController
  before_action :set_jogging_log, only: [:show, :update, :destroy]

  # GET /jogging_logs
  def index
    @jogging_logs = JoggingLog.all

    render json: @jogging_logs
  end

  # GET /jogging_logs/1
  def show
    render json: @jogging_log
  end

  # POST /jogging_logs
  def create
    @jogging_log = JoggingLog.new(jogging_log_params)

    if @jogging_log.save
      render json: @jogging_log, status: :created, location: @jogging_log
    else
      render json: @jogging_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jogging_logs/1
  def update
    if @jogging_log.update(jogging_log_params)
      render json: @jogging_log
    else
      render json: @jogging_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /jogging_logs/1
  def destroy
    @jogging_log.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jogging_log
      @jogging_log = JoggingLog.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def jogging_log_params
      params.require(:jogging_log).permit(:date, :duration, :distance, :user_id)
    end
end
