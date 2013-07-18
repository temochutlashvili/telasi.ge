# -*- encoding : utf-8 -*-
class Admin::AdminController < ApplicationController
  before_action :validate_login
  before_action :validate_admin

  protected

  def validate_admin
    unless current_user.admin
      redirect_to login_url, alert: I18n.t('models.sys_user.errors.admin_required')
    end
  end
end
