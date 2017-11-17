class ApplicationController < ActionController::API
  include Knock::Authenticable

  def handle_options_request
    head(:ok) if request.request_method == "OPTIONS"
  end

  protected

  def authorize_admin
    head :unauthorize unless !current_user.nil? && current_user.is_admin?
  end

  def authorize_manager
    head :unauthorize unless !current_user.nil? && ( current_user.is_manager? \
        || current_user.is_admin? )
  end

end
