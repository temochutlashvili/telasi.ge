# -*- encoding : utf-8 -*-
class Billing::RegionConfig
  include Mongoid::Document
  include Mongoid::Timestamps

  CENTRAL_KEY = 111

  field :regionkey, type: Integer
  field :type,      type: Integer
  field :name,      type: String
  field :address,   type: String
  field :phone,     type: String
  field :phone_exp, type: String
  field :location_latitude,  type: Float, default: 41.7341651833187
  field :location_longitude, type: Float, default: 44.78496193885803
  field :show_on_map,  type: Mongoid::Boolean, default: false
  field :trash_office, type: Mongoid::Boolean, default: false

  def self.sync
    Billing::Region.where(regtpkey: 2).each do |reg|
      if reg.regionname.index('/').nil? and reg.regionkey < 400
        region = Billing::RegionConfig.where(regionkey: reg.regionkey).first || Billing::RegionConfig.new(regionkey: reg.regionkey)
        region.type = reg.regtpkey
        region.name = reg.regionname.to_ka.strip
        region.address = reg.address # unless region.address
        region.phone = reg.phone     # unless region.phone
        region.save
      end
    end
  end

  def to_s
    self.name
  end
end
