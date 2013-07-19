# -*- encoding : utf-8 -*-
class Admin::CustomersController < Admin::AdminController
  def index
    @title = I18n.t('applications.admin.customers_title')
    @registrations = Billing::CustomerRegistration.desc(:_id).paginate(page: params[:page], per_page: 10)
  end

  def show
    @title = I18n.t('models.billing_customer_registration.title.single')
    @registration = Billing::CustomerRegistration.find(params[:id])
  end
end
