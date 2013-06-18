# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::AdminController
  def index
    @title = I18n.t('models.sys_user.users')
    @users = Sys::User.desc(:_id).paginate(per_page: 15, page: params[:page])
  end

  def show
    @title = I18n.t('models.sys_user.user_properties')
    @user = Sys::User.find(params[:id])
  end

  def nav
    super
    @nav[I18n.t('models.sys_user.users')] = admin_users_url 
    if @user
      @nav[@user.full_name] = admin_user_url(id: @user.id)
    end
  end
end
