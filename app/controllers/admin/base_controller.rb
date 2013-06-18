# -*- encoding : utf-8 -*-
class Admin::BaseController < Admin::AdminController
  def index
    @title = 'ადმინისტრირება'
    @users = Sys::User.desc(:_id).paginate(per_page: 15, page: params[:page])
  end
end
