# -*- encoding : utf-8 -*-
require 'rs'

class Network::NewCustomerItem
  USE_PERSONAL     = 0
  USE_NOT_PERSONAL = 1
  USE_SHARED       = 2
  include Mongoid::Document
  include Mongoid::Timestamps

  field :summary, type: Mongoid::Boolean
  field :address,      type: String
  field :address_code, type: String
  field :voltage, type: String
  field :power,   type: Float
  field :use,     type: Integer, default: USE_PERSONAL
  field :count,   type: Integer, default: 0
  field :rs_tin,  type: String
  field :rs_name, type: String
  field :comment, type: String
  field :customer_id, type: Integer
  field :amount, type: Float
  embedded_in :application, class_name: 'Network::NewCustomerApplication', inverse_of: :items
  validates :address, presence: { message: I18n.t('models.network_new_customer_item.errors.address_required') }
  validates :address_code, presence: { message: I18n.t('models.network_new_customer_item.errors.address_code_required') }
  validates :voltage, presence: { message: 'required' }
  validates :power, numericality: { message: I18n.t('models.network_new_customer_item.errors.illegal_power') }
  validates :count, numericality: { message: I18n.t('models.network_new_customer_item.errors.illegal_count') }
  validate :validate_type
  validate :validate_power

  def unit
    if self.voltage == '6/10' then I18n.t('models.network_new_customer_item.unit_kvolt')
    else I18n.t('models.network_new_customer_item.unit_volt') end
  end

  def customer; Billing::Customer.find(self.customer_id) if self.customer_id.present? end
  def summary?; self.summary end
  def personal?; not self.summary end

  private

  def validate_type
    if self.personal?
      if self.rs_tin.blank?
        errors.add(:rs_tin, I18n.t('models.network_new_customer_item.errors.tin_required'))
      elsif not self.rs_tin =~ /^([0-9]{11}|[0-9]{7})$/
        errors.add(:rs_tin, I18n.t('models.network_new_customer_item.errors.tin_illegal'))
      elsif self.rs_name.blank?
        self.rs_name = RS.get_name_from_tin(RS::SU.merge(tin: self.rs_tin))
        if self.rs_name.blank?
          errors.add(:rs_tin, I18n.t('models.network_new_customer_item.errors.tin_illegal'))
        end
      end
    elsif self.count.nil? or self.count <= 0
      errors.add(:count, I18n.t('models.network_new_customer_item.errors.illegal_count'))
    end
  end

  def validate_power
    if self.power.nil? or self.power <= 0
      errors.add(:power, I18n.t('models.network_new_customer_item.errors.illegal_power'))
    end
  end
end
