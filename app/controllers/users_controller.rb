class UsersController < ApplicationController
  before_action :has_manager_permissions, only: [:index]
  before_action :authenticate_user, only: [:current, :update]

  def index
    users = User.all
    render json: users, status: 200
  end

  def create
    user = User.new(user_params)
    if !current_user.nil? && User.roles[current_user.role] < User.roles[user.role]
      return head :unauthorized
    elsif user.save
      render json: user,
          status: 200
    else
      render json: { errors: user.errors.full_messages },
          status: 400
    end
  end

  def current
    render json: current_user,
        status: 200
  end

  def update
    user = User.find_by_id(params[:id])
    return head :bad_request if !user
    if authorize_to_update user
      return
    end
    if user.update(user_params)
      render json: user,
          status: 200
    else
      render json: { errors: user.errors.full_messages },
          status: 400
    end
  end

  def destroy
    user = User.find_by_id(params[:id])
    return head :bad_request if !user
    if authorize_to_update user
      return
    end
    if user.destroy
      render json: { msg: 'User has been deleted' },
          status: 200
    else
      render json: { user: user.errors.full_messages },
          status: 400
    end
  end

  private
  def user_params
    params.required(:user).permit(:email, :password, :role)
  end

  def authorize_to_update(user)
    head :unauthorized unless current_user && current_user.can_modify_user?(user)
  end

  def has_manager_permissions
    head :unauthorized unless !current_user.nil? && ( current_user.admin? \
        || current_user.manager? )
  end
end
