# -*- encoding : utf-8 -*-
class Bs::TrashItem < ActiveRecord::Base
  self.table_name  = 'bs.trashitem'
  self.primary_key = :trashitemkey
  belongs_to :customer,  class_name: 'Billing::Customer', foreign_key: :custkey
  belongs_to :operation, class_name: 'Billing::Trashoperation', foreign_key: :operationid
  belongs_to :signee,    class_name: 'Billing::Person', foreign_key: :signid
  belongs_to :assistant, class_name: 'Billing::Person', foreign_key: :assistantid

  def curr_balance
    self.balance - (self.old_balance || 0)
  end
end
