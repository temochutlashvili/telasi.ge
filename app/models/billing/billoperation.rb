# -*- encoding : utf-8 -*-
class Billing::Billoperation < ActiveRecord::Base
  self.table_name  = 'bs.billoperation'
  self.primary_key = :billoperkey
  def to_s; self.billopername.to_ka end
end
