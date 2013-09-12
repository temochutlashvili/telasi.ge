# -*- encoding : utf-8 -*-
require 'rs'

class Billing::CustomerRegistration
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, class_name: 'Sys::User'
  field :custkey, type: Integer
  field :rs_tin, type: String
  field :rs_name, type: String
  field :passport, type: String
  field :passport_serial, type: String
  field :confirmed, type: Mongoid::Boolean, default: false
  field :denied, type: Mongoid::Boolean, default: false
  field :denial_reason, type: String
  validates :rs_tin, presence: { message: I18n.t('models.billing_customer_registration.errors.tin_required') }
  # validates :custkey, uniqueness: { message: I18n.t('models.billing_customer_registration.errors.customer_duplicate'), scope: :user_id }
  validates :passport, presence: { message: I18n.t('models.billing_customer_registration.errors.passport_required') }
  validate :validate_rs_name, :validate_passport_number, :validate_denial_reason

  def customer
    @customer ||= Billing::Customer.find(self.custkey)
  end

  private

  def validate_passport_number
    if self.passport.present?
      if self.passport =~ /^[0-9]{7}$/         # old id card
        if self.passport_serial.blank?
          errors.add(:passport_serial, I18n.t('models.billing_customer_registration.errors.empty_serial'))
        elsif self.passport_serial.strip.length != 1
          errors.add(:passport_serial, I18n.t('models.billing_customer_registration.errors.illegal_serial'))
        end
      elsif self.passport =~ /^[0-9A-Z]{9}$/i  # new id card
        # that's ok
      else
        errors.add(:passport, I18n.t('models.billing_customer_registration.errors.illegal_passport'))
      end
    end
  end

  def validate_rs_name
    if self.rs_tin.present?
      self.rs_name = RS.get_name_from_tin(RS::TELASI_SU.merge(tin: self.rs_tin))
      if self.rs_name.blank?
        errors.add(:rs_tin, I18n.t('models.billing_customer_registration.errors.tin_illegal'))
      end
    end
  end

  def validate_denial_reason
    if self.denied and self.denial_reason.blank?
      errors.add(:denial_reason, I18n.t('models.billing_customer_registration.errors.denial_reason_empty'))
    end
  end
end
