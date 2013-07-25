# -*- encoding : utf-8 -*-
class Network::NewCustomerCalculation
  include Mongoid::Document
  field :voltage,   type: String
  field :power,     type: Integer
  field :amount,    type: Float
  field :days,      type: Integer
  belongs_to :tariff, class_name: 'Network::NewCustomerTariff'
  embedded_in :application, class_name: 'Network::NewCustomerApplication', inverse_of: :calculations

  def unit
    if self.voltage == '6/10' then I18n.t('models.network_new_customer_item.unit_kvolt')
    else I18n.t('models.network_new_customer_item.unit_volt') end
  end
end
