# -*- encoding : utf-8 -*-
class Network::TariffsController < Admin::AdminController
  layout 'one_column'

  def index
    @title = 'ტარიფები'
    @tariffs = Network::NewCustomerTariff.asc(:_id)
  end

  def generate_tariffs
    Network::NewCustomerTariff.generate!
    redirect_to network_tariffs_url, notice: 'ტარიფები გენერირებულია'
  end

  def nav
    @nav = { 'ქსელი' => network_home_url, 'ტარიფები' => nil }
  end
end
