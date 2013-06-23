require 'rs'

class Billing::CustomerRegistration
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, class_name: 'Sys::User'
  field :custkey, type: Integer
  field :rs_tin, type: String
  field :rs_name, type: String
  field :confirmed, type: Mongoid::Boolean, default: false
  validates :rs_tin, presence: { message: I18n.t('models.billing_customer_registration.errors.tin_required') }
  validate :get_rs_name

  def customer
    @customer ||= Billing::Customer.find(self.custkey)
  end

  private

  def get_rs_name
    if self.rs_tin
      self.rs_name = RS.get_name_from_tin(RS::SU.merge(tin: self.rs_tin))
      if self.rs_name.blank?
        errors.add(:rs_tin, I18n.t('models.billing_customer_registration.errors.tin_illegal'))
      end
    end
  end
end
