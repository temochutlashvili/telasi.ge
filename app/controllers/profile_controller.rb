# -*- encoding : utf-8 -*-
class ProfileController < ApplicationController
  def index
    @title = I18n.t('models.sys_user.actions.profile')
    @user = current_user
  end

  protected

  def nav
    [
      { label: I18n.t('menu.profile'), url: profile_url,  },
      { label: I18n.t('models.sys_user.actions.change_password'), url: change_password_url, active: ( action_name == 'change_password' ) },
    ]
  end
end
