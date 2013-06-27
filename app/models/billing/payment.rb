# -*- encoding : utf-8 -*-
class Billing::Payment < ActiveRecord::Base
  self.table_name  = 'payments.payment'
  self.primary_key = :paykey
  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
end
