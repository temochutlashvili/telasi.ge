# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :locale_config

  private

  def current_user
    @current_user ||= Sys::User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def locale_config
    session[:locale] = params[:locale] unless params[:locale].blank?
    I18n.locale = session[:locale] || 'ka'
  end

  def validate_login
    redirect_to root_url unless current_user
  end
end
