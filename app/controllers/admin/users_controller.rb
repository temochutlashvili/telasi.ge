# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::AdminController
  def index
    @title = I18n.t('models.sys_user.users')
    @search = params[:search] unless params[:search] == 'clear'
    @users = conditions(@search).desc(:_id).paginate(per_page: 15, page: params[:page])
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

  def conditions(search)
    data = Sys::User
    if search
      data = data.where(email: search[:email].mongonize) if search[:email].present?
      data = data.where(first_name: search[:first_name].mongonize) if search[:first_name].present?
      data = data.where(last_name: search[:last_name].mongonize) if search[:last_name].present?
      data = data.where(mobile: search[:mobile].mongonize) if search[:mobile].present?
    end
    data
  end
end
