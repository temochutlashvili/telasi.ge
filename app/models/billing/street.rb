# -*- encoding : utf-8 -*-
class Billing::Street < ActiveRecord::Base
  self.table_name  = 'bs.street'
  self.primary_key = :streetkey
end
