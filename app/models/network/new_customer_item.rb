# -*- encoding : utf-8 -*-
class Network::NewCustomerItem
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :application, class_name: 'Network::NewCustomerApplication', inverse_of: :items
  field :customer_id, type: Integer
  field :amount, type: Float
  field :amount_compensation, type: Float

  def customer; Billing::Customer.find(self.customer_id) if self.customer_id.present? end
end
