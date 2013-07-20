# -*- encoding : utf-8 -*-
class Admin::CustomersController < Admin::AdminController
  def index
    @title = I18n.t('applications.admin.customers_title')
    @registrations = Billing::CustomerRegistration.where(user: current_user, denied: false).desc(:_id).paginate(page: params[:page], per_page: 10)
  end

  def show
    @title = I18n.t('models.billing_customer_registration.title.single')
    @registration = Billing::CustomerRegistration.find(params[:id])
  end

  def confirm
    @registration = Billing::CustomerRegistration.find(params[:id])
    @registration.confirmed = true
    @registration.denied = false
    @registration.denial_reason = nil
    @registration.save
    redirect_to admin_show_customer_url(id: @registration.id), notice: I18n.t('models.billing_customer_registration.actions.registration_confirmed')
  end

  def deny
    # TODO:
  end
end
