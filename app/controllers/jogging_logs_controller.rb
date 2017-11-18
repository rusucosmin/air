class JoggingLogsController < ApplicationController
  before_action :authenticate_user, only: [:index, :filter, :raport]
  before_action :authorize_to_create, only: [:create]
  before_action :authenticate_as_admin, only: [:index_admin]
  before_action :set_jogging_log, only: [:show, :update, :destroy]
  before_action :authorize, only: [:show, :update, :destroy]

  # GET /jogging_logs
  def index
    @jogging_logs = current_user.jogging_logs
    render json: @jogging_logs
  end

  # GET /admin/jogging_logs
  def index_admin
    @jogging_logs = JoggingLog.all
    render json: @jogging_logs
  end

  # GET /jogging_logs/1
  def show
    render json: @jogging_log
  end

  def raport
    params.permit(:date)
    @last_date = params[:date]
    if @last_date.nil?
      jogg = current_user.jogging_logs.order("date DESC").first
      if jogg
        @last_date = jogg.date
      end
    else
      @last_date = Date.parse(@last_date)
    end

    json = {
      total_duration: 0,
      total_distance: 0,
      jogs_number: 0,
      last_date: Date.today,
      first_date: Date.today - 7
    }
    if @last_date.nil?
      render json: json
      return
    end
    @first_date = @last_date
    while(!@last_date.sunday?)
      @last_date += 1
    end
    while !@first_date.monday?
      @first_date -= 1
    end
    json[:first_date] = @first_date
    json[:second_date] = @second_date

    joggs = current_user.jogging_logs.where('date >= ? AND date <= ?', @first_date.to_s, @last_date.to_s)
    json[:jogs_number] = joggs.count
    if json[:jos_number] == 0
      render json: json
      return
    end
    joggs.each do |jogg|
      json[:total_duration] += jogg.duration
      json[:total_distance] += jogg.distance
    end
    render json: json
  end

  def filter
    params.permit(:start_date, :end_date)
#    @jogging_logs = current_user.jogging_logs
    @jogging_logs = current_user.jogging_logs.where('( ? IS NULL OR date >= ? ) AND (? IS NULL OR date <= ?)', params[:start_date], params[:start_date], params[:end_date], params[:end_date])
    render json: @jogging_logs
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

    def authorize_to_create
      head :unauthorized unless current_user && (current_user.admin? || ( params[:jogging_log] && params[:jogging_log][:user_id] && current_user.id == params[:jogging_log][:user_id].to_i))
    end

    def authorize
      head :unauthorized unless current_user && (current_user.admin? || @jogging_log.user_id == current_user.id)
    end

    def authenticate_as_admin
      head :unauthorized unless current_user && (current_user.admin?)
    end

    # Only allow a trusted parameter "white list" through.
    def jogging_log_params
      params.require(:jogging_log).permit(:date, :duration, :distance, :user_id)
    end
end
