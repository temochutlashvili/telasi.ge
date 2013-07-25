# -*- encoding : utf-8 -*-
class Network::NewCustomerCalculation
  include Mongoid::Document
  field :voltage,   type: String
  field :power,     type: Integer
  field :amount,    type: Float
  field :days,      type: Integer
  belongs_to :tariff, class_name: 'Network::NewCustomerTariff'
  embedded_in :application, class_name: 'Network::NewCustomerApplication', inverse_of: :calculations
end
