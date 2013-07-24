# -*- encoding : utf-8 -*-
class Network::NewCustomerTariff
  VOLTAGE_220 = '220'
  VOLTAGE_380 = '380'
  VOLTAGE_610 = '6/10'
  include Mongoid::Document
  include Mongoid::Timestamps
  field :voltage,    type: String
  field :power_from, type: Integer
  field :power_to,   type: Integer
  field :days_to_complete, type: Integer
  field :days_to_complete_without_resolution, type: Integer
  field :price_gel, type: Float

  def self.generate!
    if Network::NewCustomerTariff.empty?
      YAML.load_file('data/new-customer-tariffs.yml').values.each do |t|
        from, to = t['power_kwt'].split('-').map{|p| p.to_i}
        Network::NewCustomerTariff.new(
          voltage: t['voltage'],
          days_to_complete: t['days_to_complete'].to_i,
          days_to_complete_without_resolution: t['days_to_complete_without_resolution'].to_i,
          price_gel: t['price_gel'].to_f,
          power_from: from,
          power_to: to,
        ).save
      end
    end
  end
end
