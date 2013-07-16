# -*- encoding : utf-8 -*-

# BS server
Billing::Account.establish_connection       :bs
Billing::Address.establish_connection       :bs
Billing::Custcateg.establish_connection     :bs
Billing::Customer.establish_connection      :bs
Billing::ItemBill.establish_connection      :bs
Billing::Note.establish_connection          :bs
Billing::Payment.establish_connection       :bs
Billing::Region.establish_connection        :bs
Billing::Street.establish_connection        :bs
Billing::TrashCustomer.establish_connection :bs
Billing::TrashPayment.establish_connection  :bs
Billing::WaterItem.establish_connection     :bs

# REPORT server
Billing::WaterPayment.establish_connection  :report_bs
