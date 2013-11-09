# -*- encoding : utf-8 -*-
class Admin::UsersController < Admin::AdminController
  layout 'internal'

  def index
    @title = I18n.t('applications.admin.users_title')
    @users = Sys::User.desc(:_id).paginate(page: params[:page], per_page: 10)
  end

  def show
    @title = I18n.t('models.sys_user.actions.admin_show')
    @user = Sys::User.find(params[:id])
  end

  def edit
    @title = I18n.t('models.sys_user.actions.edit')
    @user = Sys::User.find(params[:id])
    if request.post?
      if @user.update_attributes(params.require(:sys_user).permit(:first_name, :last_name, :mobile, :admin, :email_confirmed))
        redirect_to admin_user_url(id: @user.id), notice: I18n.t('models.sys_user.actions.edit_complete')
      end
    end
  end

  def nav
    @nav = { 'მომხმარებლები' => admin_users_url }
    if @user
      @nav[@user.full_name] = admin_user_url(id: @user.id)
      @nav[@title] = nil unless action_name == 'show'
    end
  end
end
