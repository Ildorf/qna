require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :init_gon_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  check_authorization :unless => :devise_controller?

  private
  def init_gon_current_user
    if user_signed_in?
      gon.current_user_id = current_user.id
    else 
      gon.current_user_id = nil
    end
  end
end
