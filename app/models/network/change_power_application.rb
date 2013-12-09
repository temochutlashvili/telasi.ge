# -*- encoding : utf-8 -*-
class Network::ChangePowerApplication
  VOLTAGE_220 = '220'
  VOLTAGE_380 = '380'
  VOLTAGE_610 = '6/10'
  STATUS_DEFAULT    = 0
  STATUS_SENT       = 1
  STATUS_CANCELED   = 2
  STATUS_CONFIRMED  = 3
  STATUS_COMPLETE   = 4
  include Mongoid::Document
  include Mongoid::Timestamps
  include Network::RsName
  belongs_to :user, class_name: 'Sys::User'
  field :number,    type: String
  field :rs_tin,    type: String
  field :rs_name,   type: String
  field :rs_vat_payer, type: Mongoid::Boolean
  field :mobile,    type: String
  field :email,     type: String
  field :address,   type: String
  field :work_address, type: String
  field :address_code, type: String
  field :bank_code,    type: String
  field :bank_account, type: String
  field :status,     type: Integer, default: STATUS_DEFAULT
  # old voltage
  field :old_voltage, type: String
  field :old_power,   type: Float
  field :voltage,     type: String
  field :power,       type: Float
  field :amount,      type: Float, default: 0
  field :customer_id, type: Integer
  # dates
  field :send_date, type: Date
  field :start_date, type: Date
  field :end_date, type: Date

  validates :number, presence: { message: I18n.t('models.network_change_power_application.errors.number_required') }
  validates :user, presence: { message: 'user required' }
  validates :rs_tin, presence: { message: I18n.t('models.network_change_power_application.errors.tin_required') }
  validates :mobile, presence: { message: I18n.t('models.network_change_power_application.errors.mobile_required') }
  validates :address, presence: { message: I18n.t('models.network_change_power_application.errors.address_required') }
  validates :address_code, presence: { message: I18n.t('models.network_change_power_application.errors.address_code_required') }
  validates :bank_code, presence: { message: I18n.t('models.network_change_power_application.errors.bank_code_required') }
  validates :bank_account, presence: { message: I18n.t('models.network_change_power_application.errors.bank_account_required') }
  validates :old_voltage, presence: { message: 'required!' }
  validates :old_power, numericality: { message: I18n.t('models.network_change_power_application.errors.illegal_power') }
  validates :voltage, presence: { message: 'required!' }
  validates :power, numericality: { message: I18n.t('models.network_change_power_application.errors.illegal_power') }

  validate :validate_rs_name
  before_save :status_manager, :calculate_total_cost

  def unit
    if self.voltage == '6/10' then I18n.t('models.network_change_power_application.unit_kvolt')
    else I18n.t('models.network_change_power_application.unit_volt') end
  end
  def old_unit
    if self.old_voltage == '6/10' then I18n.t('models.network_change_power_application.unit_kvolt')
    else I18n.t('models.network_change_power_application.unit_volt') end
  end
  def bank_name; Bank.bank_name(self.bank_code) end
  def self.status_name(status); I18n.t("models.network_change_power_application.status_#{status}") end
  def self.status_icon(status)
    case status
    # when STATUS_DEFAULT    then '/icons/mail-open.png'
    when STATUS_SENT       then '/icons/mail-send.png'
    when STATUS_CANCELED   then '/icons/cross.png'
    when STATUS_CONFIRMED  then '/icons/clock.png'
    when STATUS_COMPLETE   then '/icons/tick.png'
    when STATUS_IN_BS      then '/icons/lock.png'
    else '/icons/mail-open.png' end
  end
  def status_name; Network::NewCustomerApplication.status_name(self.status) end
  def status_icon; Network::NewCustomerApplication.status_icon(self.status) end

  private

  def status_manager
    if self.status_changed?
      case self.status
      when STATUS_DEFAULT   then self.send_date = nil
      when STATUS_SENT      then self.send_date  = Date.today
      when STATUS_CONFIRMED then self.start_date = Date.today and self.plan_end_date = self.send_date + self.days
      when STATUS_COMPLETE  then self.end_date   = Date.today
      end
    end
  end

  def calculate_total_cost
    tariff_old = Network::NewCustomerTariff.tariff_for(self.old_voltage, self.old_power).price_gel
    tariff = Network::NewCustomerTariff.tariff_for(self.voltage, self.power).price_gel
    if tariff_old > tariff
      self.amount = 0
    elsif tariff_old == tariff
      if self.old_power == self.power
        self.amount = 0
      else
        per_kwh = tariff * 1.0 / self.power
        self.amount = (per_kwh * (self.power - self.old_power)).round(2)
      end
    else
      self.amount = tariff - tariff_old
    end
  end
end
