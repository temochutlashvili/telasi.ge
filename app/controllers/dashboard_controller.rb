# -*- encoding : utf-8 -*-
class DashboardController < ApplicationController
	def index
		@title = I18n.t('dashboard.title')
	end
end
