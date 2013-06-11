# -*- encoding : utf-8 -*-
class User::DashboardController < ApplicationController
  before_action :validate_login

  def index
    @title = I18n.t('dashboard.title')
  end
end
