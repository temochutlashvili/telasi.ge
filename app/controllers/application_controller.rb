# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :locale_config

  def current_user; Sys::User.current_user ||= (Sys::User.find(session[:user_id]) rescue nil) if session[:user_id] end
  helper_method :current_user

  def render(*args)
    nav if self.respond_to?(:nav)
    super
  end

  protected

  def locale_config
    session[:locale] = params[:locale] unless params[:locale].blank?
    I18n.locale = session[:locale] || 'ka'
  end

  def validate_login
    unless current_user
      session[:return_url] = request.url
      redirect_to login_url, alert: I18n.t('models.sys_user.errors.login_required')
    end
  end
end
