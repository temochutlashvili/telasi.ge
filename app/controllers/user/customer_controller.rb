# -*- encoding : utf-8 -*-
class User::CustomerController < ActionsController
  def index
    @title = I18n.t('applications.customer.title')
  end

  protected

  def nav
    @nav = super
    @nav[I18n.t('applications.customer.title')] = user_customer_url
    @nav
  end
end
