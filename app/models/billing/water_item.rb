# -*- encoding : utf-8 -*-
class Billing::WaterItem < ActiveRecord::Base
  self.table_name  = 'bs.water_item'
  self.primary_keys = [:custkey, :month, :year]
  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
end
