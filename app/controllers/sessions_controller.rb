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
    @title = I18n.t('models.sys_user.actions.login')
    if request.post?
      user = Sys::User.authenticate(params[:email], params[:password])
      if user and user.active
        session[:user_id] = user.id
        redirect_to root_url
      else
        @error = I18n.t('models.sys_user.errors.illegal_username_or_password')
      end
    end
  end

  def register
    @title = I18n.t('models.sys_user.actions.register_full')
    if request.post?
      @user = Sys::User.new(params.require(:sys_user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :mobile))
      if @user.save
        if Telasi::CONFIRM_ON_REGISTER
          # UserMailer.email_confirm(@user).deliver unless @user.email_confirmed
          # redirect_to site_registration_complete_url(email: @user.email)
        else
          # redirect_to site_login_url, notice: I18n.t('models.sys_user.actions.register_complete')
          session[:user_id] = @user.id
          redirect_to root_url
        end
      end
    else
      @user = Sys::User.new
    end
  end
end
