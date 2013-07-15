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
    @user = Sys::User.new
  end

  def restore
    @title = I18n.t('models.sys_user.actions.restore')
  end
end
