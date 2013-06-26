class Api::CustomerController < ApplicationController
  def regionkey
    customer = Billing::Customer.where(accnumb: params[:accnumb]).first
    if customer then render text: customer.region.regionkey
    else render text: nil end
  end
end
