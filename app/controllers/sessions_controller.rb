# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  layout 'site'

  def create
    if params[:provider] == 'facebook'
      user = Sys::FacebookAuth.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to '/'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def login
    @title = I18n.t('models.general.actions.login')
  end
end
