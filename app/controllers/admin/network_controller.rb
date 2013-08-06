# -*- encoding : utf-8 -*-
class Admin::NetworkController < Admin::AdminController
  layout :resolve_layout

# ==> NewCustomerApplication

  def index
    @title = 'ქსელი'
    @applications = Network::NewCustomerApplication.desc(:_id)
  end

  def new_customer
    @title = 'ქსელზე მიერთების განცხადება'
    @application = Network::NewCustomerApplication.find(params[:id])
  end

  def add_new_customer
    @title = 'ქსელზე მიერთების ახალი განცხადება'
    if request.post?
      @application = Network::NewCustomerApplication.new(new_customer_params)
      @application.user = current_user
      if @application.save
        redirect_to admin_new_customer_url(id: @application._id, tab: 'general'), notice: 'განცხადება დამატებულია'
      end
    else
      @application = Network::NewCustomerApplication.new
    end
  end

  def edit_new_customer
    @title = 'ქსელზე მიერთების განცხადების შეცვლა'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @application.update_attributes(new_customer_params)
      redirect_to admin_new_customer_url(id: @application._id, tab: 'general'), notice: 'განცხადება შეცვლილია'
    end
  end

  def add_new_customer_account
    @title = 'ახალი აბონენტის დამატება'
    @application = Network::NewCustomerApplication.find(params[:id])
    if request.post?
      @account = Network::NewCustomerItem.new(account_params)
      @account.application = @application
      @account.summary = params[:type] == 'summary'
      if @account.save
        @application.calculate!
        redirect_to admin_new_customer_url(id: @application.id, tab: 'accounts'), notice: 'აბონენტი დამატებულია'
      end
    else
      @account = Network::NewCustomerItem.new
    end
  end

# ==> Tariffs

  # TODO: tariffs page
  # def tariffs
  #   @titlte = 'ტარიფები'
  #   @tariffs = Network::NewCustomerTariff.asc(:_id)
  # end

  def generate_tariffs
    Network::NewCustomerTariff.generate!
    redirect_to admin_network_url, notice: 'ტარიფები გენერირებულია'
  end

  private

  def resolve_layout
    # case action_name
    # when 'index' then 'one_column'
    # else 'two_column' end
    'one_column'
  end

  def new_customer_params; params.require(:network_new_customer_application).permit(:rs_tin, :mobile, :email, :address, :bank_code, :bank_account) end
  def account_params; params.require(:network_new_customer_item).permit(:address, :address_code, :voltage, :power, :use, :rs_tin, :count) end
end
