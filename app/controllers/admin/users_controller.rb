# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::AdminController
  def index
    @title = I18n.t('models.sys_user.users')
    @users = Sys::User.desc(:_id).paginate(per_page: 15, page: params[:page])
  end

  def nav
    super
    @nav[I18n.t('models.sys_user.users')] = admin_users_url 
  end
end
