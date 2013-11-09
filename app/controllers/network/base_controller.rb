# -*- encoding : utf-8 -*-
class Network::BaseController < Network::NetworkController
  layout 'internal'

  def index
    @title = 'ქსელი'
    @new_customers = Network::NewCustomerApplication.desc(:_id).paginate(page: params[:page_new], per_page: 10)
    @change_powers = Network::ChangePowerApplication.desc(:_id).paginate(page: params[:page_change], per_page: 10)
  end
end
