# -*- encoding : utf-8 -*-
class Admin::NetworkController < Admin::AdminController
  def index
    @title = 'ქსელი'
    @tariffs = Network::NewCustomerTariff.asc(:_id)
  end

  def generate_tariffs
    Network::NewCustomerTariff.generate!
    redirect_to admin_network_url
  end
end
