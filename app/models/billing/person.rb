# -*- encoding : utf-8 -*-
class Billing::Person < ActiveRecord::Base
  self.table_name  = 'bs.person'
  self.primary_key = :perskey
  def to_s; self.persname.to_ka end
end
