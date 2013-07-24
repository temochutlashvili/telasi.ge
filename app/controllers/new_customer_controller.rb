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
      @application = Network::NewCustomerApplication.new(application_params)
      @application.user = user
      if @application.save
        # TODO: redirect to the next step
      end
    else
      @application = Network::NewCustomerApplication.new(mobile: user.mobile, email: user.email)
    end
  end

  def show
    with_application do
      @title = I18n.t('models.network_new_customer_application.actions.show_page.title')
    end
  end

  def edit
    with_application do
      @title = I18n.t('models.network_new_customer_application.actions.edit.title')
      if request.put?
        if @application.update_attributes(application_params)
          redirect_to show_new_customer_url(id: @application.id)
        end
      end
    end
  end

  private

  def with_application
    @application = Network::NewCustomerApplication.where(user: current_user, _id: params[:id]).first
    if @application
      @nav = nav
      yield if block_given?
    else
      redirect_to new_customer_url, alert: 'not permitted'
    end
  end

  def nav
    [
      { label: I18n.t('models.network_new_customer_application.actions.nav.main'), url: show_new_customer_url(id: @application.id), active: (action_name == 'show') },
      { label: I18n.t('models.network_new_customer_application.actions.nav.accounts'), url: new_customer_accounts_url(id: @application.id), active: (action_name == 'accounts') },
      { label: I18n.t('models.network_new_customer_application.actions.nav.payments'), url: new_customer_payments_url(id: @application.id), active: (action_name == 'payments') },
    ]
  end

  def application_params
    params.require(:network_new_customer_application).permit(:rs_tin, :mobile, :email, :address, :bank_code, :bank_account)
  end
end
