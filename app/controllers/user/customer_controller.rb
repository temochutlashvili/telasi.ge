# -*- encoding : utf-8 -*-
class User::CustomerController < ActionsController
  def index
    @title = I18n.t('applications.customer.title')
    @customers = []
  end

  def add_customer
    @title = I18n.t('models.billing_customer.actions.add_customer')
  end

  protected

  def nav
    @nav = super
    @nav[I18n.t('applications.customer.title')] = user_customer_url
    if action_name == 'add_customer'
      @nav['title'] = nil
    end
    @nav
  end
end
