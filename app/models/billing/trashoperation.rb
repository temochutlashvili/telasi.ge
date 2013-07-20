# -*- encoding : utf-8 -*-
class Billing::Trashoperation < ActiveRecord::Base
  self.table_name  = 'bs.trashoperation'
  self.primary_key = :operationid
  def to_s; self.description.to_ka end
end
