# -*- encoding : utf-8 -*-
require 'rs'

class Billing::CustomerRegistration
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, class_name: 'Sys::User'
  field :custkey, type: Integer
  field :rs_tin, type: String
  field :rs_name, type: String
  field :dob, type: Date
  field :confirmed, type: Mongoid::Boolean, default: false
  field :denied, type: Mongoid::Boolean, default: false
  field :denial_reason, type: String

  validates :custkey, uniqueness: { message: I18n.t('models.billing_customer_registration.errors.customer_duplicate'), scope: :user_id }
  validates :rs_tin, presence: { message: I18n.t('models.billing_customer_registration.errors.tin_required') }
  validates :dob, presence: { message: I18n.t('models.billing_customer_registration.errors.dob_required') }
  validate :validate_rs_name, :validate_denial_reason

  def customer; @customer ||= Billing::Customer.find(self.custkey) end
  def cra_url; "http://service.telasi.ge/cra/by_name_and_dob?first_name=#{first_name}&last_name=#{last_name}&date=#{dob.strftime('%d-%b-%Y')}" end
  def first_name; self.rs_name.split(' ')[0] end
  def last_name; self.rs_name.split(' ')[1] end

  private

  def validate_rs_name
    if self.rs_tin.present?
      self.rs_name = RS.get_name_from_tin(RS::TELASI_SU.merge(tin: self.rs_tin))
      errors.add(:rs_tin, I18n.t('models.billing_customer_registration.errors.tin_illegal')) if self.rs_name.blank?
    end
  end

  def validate_denial_reason
    if self.denied and self.denial_reason.blank?
      errors.add(:denial_reason, I18n.t('models.billing_customer_registration.errors.denial_reason_empty'))
    end
  end
end
