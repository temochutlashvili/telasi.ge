# -*- encoding : utf-8 -*-
class Admin::CustomersController < Admin::AdminController
  def index
    @title = I18n.t('applications.admin.customers_title')
    @registrations = Billing::CustomerRegistration.desc(:_id).paginate(page: params[:page], per_page: 10)
  end
end
