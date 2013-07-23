# -*- encoding : utf-8 -*-
class NewCustomerController < ApplicationController
  before_action :validate_login

  def index
    @title = I18n.t('models.network_new_customer_application.actions.index_page.title')
    # TODO: applications
  end

  def new
    @title = I18n.t('models.network_new_customer_application.actions.new')
    user = current_user
    @application = Network::NewCustomerApplication.new(mobile: user.mobile, email: user.email)
    # TODO: save application
  end
end
