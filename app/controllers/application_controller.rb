class ApplicationController < ActionController::Base
  protect_from_forgery

  require 'sir-trevor-rails'

  before_filter :store_location
  helper_method :signed_in_as_owner?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end
  
  def current_ability
    @current_ability ||= Ability.new(current_admin_user)
  end

  def signed_in_as_owner?(resource)
    if user_signed_in? && resource == current_user
      true
    elsif resource.class != User && resource.user.present? && user_signed_in?
      if !current_user.role.nil?
        true
      else
        resource.user == current_user
      end
    else
      false
    end
  end

  def authenticate_admin_user!
  	redirect_to new_user_session_path and return if user_signed_in? && current_user.role.nil?
    authenticate_user!
  end

  def current_admin_user
    return nil if user_signed_in? && current_user.role.nil?
    current_user 
  end
       
  private
  
    def store_location
      if !user_signed_in? && params[:action] != "create" && params[:action] != "update"
        
        if params[:next]
          session[:return_to] = params[:next]
        else
          session[:return_to] = nil
        end
        
      end
    end

    def stored_location_for(resource_or_scope)
      session[:return_to] || super
    end
  
    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || member_path(resource_or_scope) || signed_in_root_path(resource_or_scope)
    end
  
end