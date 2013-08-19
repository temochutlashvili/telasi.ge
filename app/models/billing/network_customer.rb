# -*- encoding : utf-8 -*-
class Billing::NetworkCustomer < ActiveRecord::Base
  self.table_name  = 'bs.zdepozit_cust_qs'
  self.primary_key = 'zdepozit_cust_id'

  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
end
