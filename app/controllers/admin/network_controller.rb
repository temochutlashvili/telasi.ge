# -*- encoding : utf-8 -*-
class Admin::NetworkController < Admin::AdminController
  layout :resolve_layout

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
        redirect_to admin_network_url, notice: 'განცხადება დამატებულია'
      end
    else
      @application = Network::NewCustomerApplication.new
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

  def new_customer_params
    params.require(:network_new_customer_application).permit(:rs_tin, :mobile, :email, :address, :bank_code, :bank_account)
  end
end
