# -*- encoding : utf-8 -*-
class DashboardController < ApplicationController
	def index
		@title = I18n.t('dashboard.title')
	end

  def login
    @title = I18n.t('dashboard.login')
  end

  def register
    @title = I18n.t('models.sys_user.actions.register')
    if request.post?
      @user = Sys::User.new(params.require(:sys_user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :mobile))
      if @user.save
        UserMailer.email_confirmation(@user).deliver if @user.email_confirm_hash
        redirect_to register_complete_url # (email: @user.email)
      end
    else
      @user = Sys::User.new
    end
  end

  def register_complete
    @title = I18n.t('models.sys_user.actions.register_complete')
  end

  def restore
    @title = I18n.t('models.sys_user.actions.restore')
  end

  def confirm
    @user = Sys::User.find(params[:id]) rescue nil
    if @user and @user.confirm_email!(params[:c]) then @success = I18n.t('models.sys_user.actions.confirm_success')
    else @error = I18n.t('models.sys_user.actions.confirm_failure') end
  end
end
