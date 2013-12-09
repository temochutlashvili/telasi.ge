# -*- encoding : utf-8 -*-
class Billing::WaterCustomer < ActiveRecord::Base
  self.table_name  = 'bs.water_customer'
  self.primary_key = :custkey
  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
end
