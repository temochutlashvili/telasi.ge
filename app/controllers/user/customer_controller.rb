# -*- encoding : utf-8 -*-
class User::CustomerController < ActionsController
  def index
    @title = I18n.t('applications.customer.title')
    @customers = Billing::CustomerRegistration.where(user: current_user)
  end

  def add_customer
    @title = I18n.t('models.bs.customer.actions.add_customer')
    @search = { accnumb: params[:accnumb] }
    @customer = Billing::Customer.where(accnumb: @search[:accnumb].to_geo).first if @search[:accnumb].present?
    if @customer and params[:step] == '3'
      @step = 3
      if request.post?
        @registration = Billing::CustomerRegistration.new(params.require(:billing_customer_registration).permit(:rs_tin))
        @registration.user = current_user
        @registration.custkey = @customer.custkey
        if @registration.save
          redirect_to user_add_customer_url(step: 4)
        end
      else
        @registration = Billing::CustomerRegistration.new
      end
    elsif @customer
      @duplication = Billing::CustomerRegistration.where(custkey: @customer.custkey, user: current_user).first.present?
      @step = 2
    elsif params[:step] == '4'
      @step = 4
    else
      @step = 1
    end
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
