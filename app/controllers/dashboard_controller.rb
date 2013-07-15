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
      @user.save
    else
      @user = Sys::User.new
    end
  end

  def restore
    @title = I18n.t('models.sys_user.actions.restore')
  end
end
