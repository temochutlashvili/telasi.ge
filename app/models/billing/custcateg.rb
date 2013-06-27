# -*- encoding : utf-8 -*-
class Billing::Custcateg < ActiveRecord::Base
  self.table_name  = 'bs.custcateg'
  self.primary_key = :custcatkey
  def to_s; self.custcatname.strip.to_ka end
end
