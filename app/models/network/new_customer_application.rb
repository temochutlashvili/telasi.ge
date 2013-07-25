# -*- encoding : utf-8 -*-
class Network::NewCustomerApplication
  STATUS_DEFAULT    = 0
  STATUS_SENT       = 1
  STATUS_CANCELED   = 2
  STATUS_CONFIRMED  = 3
  STATUS_COMPLETE   = 4
  VOLTAGE_220 = '220'
  VOLTAGE_380 = '380'
  VOLTAGE_610 = '6/10'
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user, class_name: 'Sys::User'
  field :number,    type: Integer
  field :rs_tin,    type: String
  field :rs_name,   type: String
  field :mobile,    type: String
  field :email,     type: String
  field :address,   type: String
  field :bank_code,    type: String
  field :bank_account, type: String
  field :status,     type: Integer, default: STATUS_DEFAULT
  field :amount, type: Float, default: 0
  field :days,   type: Integer, default: 0
  field :need_resolution, type: Mongoid::Boolean, default: true
  embeds_many :items, class_name: 'Network::NewCustomerItem', inverse_of: :application
  embeds_many :calculations, class_name: 'Network::NewCustomerCalculation', inverse_of: :application
  has_many :files, class_name: 'Sys::File'
  validates :user, presence: { message: 'user required' }
  validates :rs_tin, presence: { message: I18n.t('models.network_new_customer_application.errors.tin_required') }
  validates :mobile, presence: { message: I18n.t('models.network_new_customer_application.errors.mobile_required') }
  validates :email, presence: { message: I18n.t('models.network_new_customer_application.errors.email_required') }
  validates :address, presence: { message: I18n.t('models.network_new_customer_application.errors.address_required') }
  validates :bank_code, presence: { message: I18n.t('models.network_new_customer_application.errors.bank_code_required') }
  validates :bank_account, presence: { message: I18n.t('models.network_new_customer_application.errors.bank_account_required') }
  validate :validate_rs_name
  before_create :assign_number

  def status_name; I18n.t("models.network_new_customer_application.status_#{self.status}") end

  def calculate!
    self.calculations.destroy_all
    self.amount = 0
    self.days   = 0
    calc_220_in_380 = cnt(VOLTAGE_220) > 2
    calculate_voltage(VOLTAGE_220) unless calc_220_in_380
    calculate_voltage(VOLTAGE_380, calc_220_in_380) 
    calculate_voltage(VOLTAGE_610)
    self.save
    # self.application.recalculate!
  end

  private

  def cnt(volt); self.items.where(voltage: volt).inject(0){ |cnt, x| cnt + (x.summary? ? x.count : 1) } end

  def calculate_voltage(volt, with_220 = false)
    items = self.items.where(voltage: volt)
    items += self.items.where(voltage: VOLTAGE_220) if with_220
    if volt == VOLTAGE_220
      count = cnt(volt)
      count += cnt(VOLTAGE_220) if with_220
    else
      count = 1
    end
    power = items.inject(0){ |sum, x| sum + x.power * ( volt == VOLTAGE_220 && x.summary? ? x.count : 1 ) }
    if volt == VOLTAGE_220
      tariff = nil
      items.each do |item|
        tariff = Network::NewCustomerTariff.tariff_for(volt, item.power)
        break if tariff.nil?
      end
    else
      tariff = Network::NewCustomerTariff.tariff_for(volt, power)
    end
    # calculate amount
    if tariff
      if power > 0
        tariff_days = self.need_resolution ? tariff.days_to_complete : tariff.days_to_complete_without_resolution
        self.calculations << Network::NewCustomerCalculation.new(voltage: volt, power: power, tariff_id: tariff.id, amount: tariff.price_gel * count, days: tariff_days)
        self.amount += tariff.price_gel * count unless self.amount.nil?
        self.days = tariff_days if self.days < tariff_days
      end
    else
      if power > 0
        self.calculations << Network::NewCustomerCalculation.new(voltage: volt, power: power, tariff_id: nil)
        self.amount = nil
      end
    end
  end

  def assign_number; self.number = (Network::NewCustomerApplication.last.number rescue 1) end

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
