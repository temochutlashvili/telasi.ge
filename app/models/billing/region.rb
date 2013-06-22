# -*- encoding : utf-8 -*-
class Billing::Region < ActiveRecord::Base
  self.table_name  = 'bs.region'
  self.primary_key = :regionkey

  def address
    location = self.location
    if location
      a = self.location.split('T')[0]
      a && a.to_ka.gsub('N', '№').gsub(',', ', ').gsub('.', '. ')
    end
  end

  def phone
    location = self.location
    if location
      p = self.location.split('T')[1]
      p && p.to_ka.gsub(',', ', ')
    end
  end

  def to_s
    self.regionname
  end

  # def ext_region
  #   Ext::Region.where(regionkey: self.regionkey).first
  # end
end
