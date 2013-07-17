# -*- encoding : utf-8 -*-
class ProfileController < ApplicationController
  before_action :nav

  def index
    @title = I18n.t('models.sys_user.actions.profile')
    @user = current_user
  end

  def change_password
    @title = I18n.t('models.sys_user.actions.change_password')
    if request.post?
      if params[:password].blank? then @error = I18n.t('models.sys_user.errors.empty_password')
      elsif params[:password] != params[:password_confirmation] then @error = I18n.t('models.sys_user.errors.password_not_match')
      else
        user = Sys::User.authenticate(current_user.email, params[:old_password])
        if user then
          user.password = params[:password]
          user.save
          redirect_to profile_url, notice: I18n.t('models.sys_user.actions.change_password_complete')
        else
          @error = I18n.t('models.sys_user.errors.illegal_login')
        end
      end
    end
  end

  protected

  def nav
    @nav = [
      { label: I18n.t('menu.profile'), url: profile_url, active: ( action_name == 'index' ) },
      { label: I18n.t('models.sys_user.actions.change_password'), url: change_password_url, active: ( action_name == 'change_password' ) },
    ]
  end
end
