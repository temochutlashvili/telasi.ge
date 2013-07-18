# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::AdminController
  def index
    @title = I18n.t('applications.admin.users_title')
  end
end
