# -*- encoding : utf-8 -*-
class CustomersController < ApplicationController
  before_action :validate_login, :nav

  def index
    @title = I18n.t('menu.customers')
    @registrations = Billing::CustomerRegistration.where(user: current_user)
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
    # TODO:
  end

  protected

  def nav; end
end
