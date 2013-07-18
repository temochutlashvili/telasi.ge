# -*- encoding : utf-8 -*-
class CustomersController < ApplicationController
  before_action :validate_login, :nav

  def index
    @title = I18n.t('menu.customers')
    @registrations = Billing::CustomerRegistration.where(user: current_user)
  end

  protected

  def nav; end
end
