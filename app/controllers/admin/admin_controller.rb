# -*- encoding : utf-8 -*-
class Admin::AdminController < ActionsController
  def nav; super; @nav[I18n.t('applications.admin.title')] = admin_home_url end
end
