# -*- encoding : utf-8 -*-
class Api::CustomersController < Api::ApiController
  def tariffs
    customer = Billing::Customer.where(accnumb: params[:accnumb].to_geo).first
    render json: {
      id: customer.custkey, name: customer.custname.to_ka,
      number: customer.accnumb.to_ka, address: customer.address.to_s,
      accounts: customer.accounts.map {|x|
        tar = x.tariffs.last.tariff
        { id: x.acckey, number: x.accid.to_ka, meter: x.mtnumb, address: x.address.to_s,
          status: x.statuskey == 0,
          tariff: {
            id: tar.compkey, name: tar.compname.to_ka, amount: tar.amount
          }
        }
      }
    }
  end
end
