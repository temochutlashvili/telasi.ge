# -*- encoding : utf-8 -*-
class Admin::NetworkController < Admin::AdminController
  def index
    @tariffs = Network::NewCustomerTariff.asc(:_id)
  end
end
