# -*- encoding : utf-8 -*-
class CustomersController < ApplicationController
  before_action :validate_login, :nav

  def index
    @title = I18n.t('menu.customers')
    @registrations = Billing::CustomerRegistration.where(user: current_user, denied: false).desc(:_id)
  end

  def search
    @title = I18n.t('models.billing_customer.actions.search')
    if params[:accnumb].present?
      customer = Billing::Customer.where(accnumb: params[:accnumb].to_lat).first
      redirect_to customer_info_url(custkey: customer.custkey) if customer
    end
  end

  def info
    @title = I18n.t('models.billing_customer.actions.info')
    @customer = Billing::Customer.find(params[:custkey])
    if request.post?
      @registration = Billing::CustomerRegistration.new(params.require(:billing_customer_registration).permit(:rs_tin, :passport, :passport_serial))
      @registration.custkey = @customer.custkey
      @registration.user = current_user
      @registration.confirmed = false
      @registration.denied = false
      if @registration.save
        redirect_to add_customer_complete_url
      end
    else
      @registration = Billing::CustomerRegistration.new
    end
  end

  def complete
    @title = I18n.t('models.billing_customer_registration.actions.add_complete')
  end

  protected

  def nav; end
end
