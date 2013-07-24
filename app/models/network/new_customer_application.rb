# -*- encoding : utf-8 -*-
class Network::NewCustomerApplication
  STATUS_DEFAULT    = 0
  STATUS_SENT       = 1
  STATUS_CANCELED   = 2
  STATUS_CONFIRMED  = 3
  STATUS_COMPLETE   = 4
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user, class_name: 'Sys::User'
  field :number,    type: Integer
  field :rs_tin,    type: String
  field :rs_name,   type: String
  # field :vat_payer, type: Mongoid::Boolean
  field :mobile,    type: String
  field :email,     type: String
  field :address,   type: String
  field :bank_code,    type: String
  field :bank_account, type: String
  field :status,     type: Integer, default: STATUS_DEFAULT
  validates :user, presence: { message: 'user required' }
  validates :rs_tin, presence: { message: I18n.t('models.network_new_customer_application.errors.tin_required') }
  validates :mobile, presence: { message: I18n.t('models.network_new_customer_application.errors.mobile_required') }
  validates :email, presence: { message: I18n.t('models.network_new_customer_application.errors.email_required') }
  validates :address, presence: { message: I18n.t('models.network_new_customer_application.errors.address_required') }
  validates :bank_code, presence: { message: I18n.t('models.network_new_customer_application.errors.bank_code_required') }
  validates :bank_account, presence: { message: I18n.t('models.network_new_customer_application.errors.bank_account_required') }
  validate :validate_rs_name
  before_create :assign_number

  private

  def assign_number; self.number = (Network::NewCustomerApplication.last.number rescue 1) end
  def status_name; I18n.t("models.network_new_customer_application.status.#{self.status}") end

  def validate_rs_name
    if self.rs_tin.present?
      self.rs_name = RS.get_name_from_tin(RS::SU.merge(tin: self.rs_tin))
      # self.vat_payer = RS.is_vat_payer(RS::SU)
      if self.rs_name.blank?
        errors.add(:rs_tin, I18n.t('models.network_new_customer_application.errors.tin_illegal'))
      end
    end
  end
end
