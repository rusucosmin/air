class HomeController < ApplicationController
  before_action :authenticate_user, only: [:auth]
  def index
    render json: {
        service: 'auth-api'
      }, status: 200
  end

  def auth
    render json: {
        msg: "You are currenty Logged in as #{current_user.email}"
      }, status: 200
  end
end
