# -*- encoding : utf-8 -*-
class Network::TariffsController < Admin::AdminController
  layout 'one_column'

  def index
    @title = 'ტარიფები'
    Admin::Network::TariffsController
    # @tariffs = Network::NewCustomerTariff.asc(:_id)
  end

  def generate_tariffs
    Network::NewCustomerTariff.generate!
    redirect_to admin_tariffs_url, notice: 'ტარიფები გენერირებულია'
  end
end
