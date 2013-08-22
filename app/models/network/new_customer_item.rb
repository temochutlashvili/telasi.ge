# -*- encoding : utf-8 -*-
require 'rs'

class Network::NewCustomerItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address,      type: String
  field :address_code, type: String
  field :rs_tin,  type: String
  field :rs_name, type: String
  field :customer_id, type: Integer
  field :amount, type: Float

  embedded_in :application, class_name: 'Network::NewCustomerApplication', inverse_of: :items
  validates :address, presence: { message: I18n.t('models.network_new_customer_item.errors.address_required') }
  validates :address_code, presence: { message: I18n.t('models.network_new_customer_item.errors.address_code_required') }
  validate :validate_type

  def customer; Billing::Customer.find(self.customer_id) if self.customer_id.present? end

  private
  def validate_type
    if self.rs_tin.blank?
      errors.add(:rs_tin, I18n.t('models.network_new_customer_item.errors.tin_required'))
    elsif not self.rs_tin =~ /^([0-9]{11}|[0-9]{7})$/
      errors.add(:rs_tin, I18n.t('models.network_new_customer_item.errors.tin_illegal'))
    else
      self.rs_name = RS.get_name_from_tin(RS::SU.merge(tin: self.rs_tin))
      if self.rs_name.blank?
        errors.add(:rs_tin, I18n.t('models.network_new_customer_item.errors.tin_illegal'))
      end
    end
  end
end
