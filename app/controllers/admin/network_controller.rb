# -*- encoding : utf-8 -*-
class Admin::NetworkController < Admin::AdminController
  layout :resolve_layout

# ==> NewCustomerApplication

  

# ==> Tariffs

  def tariffs
    @title = 'ტარიფები'
    @tariffs = Network::NewCustomerTariff.asc(:_id)
  end

  def generate_tariffs
    Network::NewCustomerTariff.generate!
    redirect_to admin_tariffs_url, notice: 'ტარიფები გენერირებულია'
  end

  private

  def resolve_layout; 'one_column' end
  def new_customer_params; params.require(:network_new_customer_application).permit(:rs_tin, :mobile, :email, :address, :address_code, :bank_code, :bank_account, :need_resolution, :voltage, :power) end
  def account_params; params.require(:network_new_customer_item).permit(:address, :address_code, :rs_tin, :customer_id) end
end
