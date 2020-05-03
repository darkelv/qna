class ApplicationController < ActionController::Base
  before_action :gon_user

  def gon_user
    gon.user_id = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js { head(:forbidden) }
      format.json { head(:forbidden) }
      format.html { redirect_to root_url, alert: exception.message, status: 403}
    end
  end
  # check_authorization unless: :devise_controller?
end
