
class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_variant

  protected

  after_filter :store_location

def store_location
  # store last url - this is needed for post-login redirect to whatever the user last visited.
  if (request.fullpath != "/users/sign_in" &&
      request.fullpath != "/users/sign_up" &&
      request.fullpath != "/users/password" &&
      request.fullpath != "/users/sign_out" &&
      !request.xhr?) # don't store ajax calls
    session[:previous_url] = request.fullpath 
  end
end

def after_sign_in_path_for(resource)
  session[:previous_url] || root_path
end
  
def after_sign_out_path_for(resource_or_scope)
  request.referrer
end
  
def after_sign_up_path_for(resource_or_scope)
  request.referrer
end

  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :bio, :avatar, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :bio, :avatar, :password, :remember_me) }
  end

  private

      def set_variant
        request.variant = :tablet if request.user_agent =~ /mobile|android|touch|webos|hpwos/i
  end
end