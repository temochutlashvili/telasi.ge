# -*- encoding : utf-8 -*-
class Network::NewCustomerTariff
  VOLTAGE_220 = '220'
  VOLTAGE_380 = '380'
  VOLTAGE_610 = '610'
  include Mongoid::Document
  include Mongoid::Timestamps
  field :voltage,    type: String
  field :power_from, type: Integer
  field :power_to,   type: Integer
  field :days_to_complete, type: Integer
  field :days_to_complete_without_resolution, type: Integer
  field :price_gel, type: Float

end
