# -*- encoding : utf-8 -*-
class Admin::NetworkController < Admin::AdminController
  layout :resolve_layout

  def index
    @title = 'ქსელი'
    @applications = Network::NewCustomerApplication.desc(:_id)
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
    case action_name
    when 'index' then 'one_column'
    else 'two_column' end
  end
end
