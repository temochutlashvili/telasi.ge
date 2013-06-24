# -*- encoding : utf-8 -*-
class Billing::ItemBill < ActiveRecord::Base
  self.table_name  = 'bs.item_bill'
  self.primary_key = :itemkey
  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
end
