# -*- encoding : utf-8 -*-
class Admin::BaseController < Admin::AdminController
  def index
    @title = 'ადმინისტრირება'
  end
end
