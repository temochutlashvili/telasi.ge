# -*- encoding : utf-8 -*-
class User::CustomerController < ActionsController
  def index
    @title = I18n.t('applications.customer.title')
    @customers = []
  end

  def add_customer
    @title = I18n.t('models.bs.customer.actions.add_customer')
  end

  def customer_balance
    @title = I18n.t('models.bs.customer.actions.customer_balance')
    @search = { accnumb: params[:accnumb] }
    if @search[:accnumb].present?
      @customer = Billing::Customer.where(accnumb: @search[:accnumb].to_geo).first
    end
  end

  protected

  def nav
    @nav = super
    @nav[I18n.t('applications.customer.title')] = user_customer_url
    if [ 'add_customer', 'customer_balance' ].include? action_name
      @nav[@title] = nil
    end
    @nav
  end
end
