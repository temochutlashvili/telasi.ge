# -*- encoding : utf-8 -*-
class DashboardController < ApplicationController
	def index
		@title = I18n.t('dashboard.title')
	end

  def login
    @title = I18n.t('dashboard.login')
  end
end
