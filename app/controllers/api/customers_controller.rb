# -*- encoding : utf-8 -*-
class Api::CustomersController < Api::ApiController
  def tariffs; @customer = Billing::Customer.where(accnumb: params[:accnumb].to_geo).first end
end
