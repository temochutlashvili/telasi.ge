# -*- encoding : utf-8 -*-
class NewCustomerController < ApplicationController
  before_action :validate_login

  def index
    @title = I18n.t('models.network_new_customer_application.actions.index_page.title')
    @applications = Network::NewCustomerApplication.where(user: current_user).desc(:_id)
  end

  def new
    @title = I18n.t('models.network_new_customer_application.actions.new')
    user = current_user
    if request.post?
      @application = Network::NewCustomerApplication.new(params.require(:network_new_customer_application).permit(:rs_tin, :mobile, :email, :address, :bank_code, :bank_account))
      @application.user = user
      if @application.save
        # TODO: redirect to the next step
      end
    else
      @application = Network::NewCustomerApplication.new(mobile: user.mobile, email: user.email)
    end
  end
end
