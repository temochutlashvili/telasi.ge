# -*- encoding : utf-8 -*-
class Billing::Paypoint < ActiveRecord::Base
  self.table_name  = 'payments.paypoint'
  self.primary_key = :ppointkey
  def network_paypoints; Billing::Paypoint.where('ppointkey IN (?)', Network::PAYPOINTS) end
  def to_s; self.pointname.to_ka end
end
