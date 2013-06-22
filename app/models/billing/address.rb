# -*- encoding : utf-8 -*-
class Billing::Address < ActiveRecord::Base
  self.table_name  = 'bs.address'
  self.primary_key = :premisekey
  belongs_to :street,   class_name: 'Billing::Street',   foreign_key: :streetkey
  belongs_to :region,   class_name: 'Billing::Region',   foreign_key: :regionkey

  def to_s
    a = ''
    a += "#{self.postindex.to_ka.strip}, "   unless self.postindex.blank?
    a += self.street.streetname.to_ka.strip
    a += " №#{self.house.to_ka.strip}"       unless self.house.blank?
    a += " კორპ. #{self.building.to_ka.strip}"   unless self.building.blank?
    a += ", სად. #{self.porch.to_ka.strip}" unless self.porch.blank?
    a += ", ბ. #{self.flate.to_ka.strip}"   unless self.flate.blank?
    a
  end
end
