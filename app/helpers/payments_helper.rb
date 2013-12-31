# -*- encoding : utf-8 -*-
module PaymentsHelper

    def servicetext(serviceid)
       return t("services.#{serviceid.downcase}")
    end

    def merchant_collection
    	Hash[Payge::PAY_SERVICES.map { |x| [x[:ServiceName],x[:ServiceID]] } ]
    end
end
