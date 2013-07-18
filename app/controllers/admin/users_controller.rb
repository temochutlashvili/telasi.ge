# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::AdminController
  def index
    @title = I18n.t('applications.admin.users_title')
    @users = Sys::User.desc(:_id).paginate(page: params[:page], per_page: 10)
  end

  def show
    @title = I18n.t('models.sys_user.actions.admin_show')
    @user = Sys::User.find(params[:id])
  end
end
