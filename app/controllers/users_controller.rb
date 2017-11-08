class UsersController < ApplicationController
  before_action :has_manager_permissions, only: [:index]

  def index
    users = User.all
    render json: users, status: 200
  end

  def create
    user = User.new(user_params)
    if !current_user.nil? && User.roles[current_user.role] < User.roles[user.role]
      head :unauthorized
    elsif user.save
      render json: user,
          status: 200
    end
  end

  def current
    user = User.find(params[:id])
    if user.update(user_params)
      render json: usser,
          status: 200
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json user,
          status: 200
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy?
      render json: { status: 200, msg: 'User has been deleted'}
    end
  end

  private
  def user_params
    params.required(:user).permit(:email, :password, :role)
  end

  def authorize
    head :unauthorized unless current_user && current_user.can_modify_user?(params[:id])
  end

  def has_manager_permissions
    head :unauthorized unless !current_user.nil? && ( current_user.admin? \
        || current_user.manager? )
  end
end
