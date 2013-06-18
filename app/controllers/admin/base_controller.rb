# -*- encoding : utf-8 -*-
class Admin::BaseController < Admin::AdminController
  def index
    @title = I18n.t('applications.admin.title')
    @users = Sys::User.desc(:_id).paginate(per_page: 15, page: params[:page])
  end
end
