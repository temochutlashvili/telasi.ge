# -*- encoding : utf-8 -*-
class Billing::TrashPayment < ActiveRecord::Base
  self.table_name  = 'payments.trashpayment'
  self.primary_key = :paykey
  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
end
