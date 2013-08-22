# -*- encoding : utf-8 -*-
class Network::NewCustomerApplication
  STATUS_DEFAULT    = 0
  STATUS_SENT       = 1
  STATUS_CANCELED   = 2
  STATUS_CONFIRMED  = 3
  STATUS_COMPLETE   = 4
  STATUS_IN_BS      = 5
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
  field :address_code, type: String
  field :bank_code,    type: String
  field :bank_account, type: String
  field :status,     type: Integer, default: STATUS_DEFAULT
  # გამოთვლის დეტალები და ბილინგთან კავშირი
  field :need_resolution,  type: Mongoid::Boolean, default: true
  field :voltage,     type: String
  field :power,       type: Float
  field :amount,      type: Float, default: 0
  field :days,        type: Integer, default: 0
  field :customer_id, type: Integer
  ### დღეების ანგარიში ###
  # send_date, არის თარიღი, როდესაც მოხდა განცხადების თელასში გამოგზავნა
  field :send_date, type: Date
  # start_date, არის თარიღი, როდესაც თელასმა განხცადება წამოებაში მიიღო
  field :start_date, type: Date
  # plan_end_date / end_date, არის თარიღი (გეგმიური / რეალური), როდესაც დასრულდება
  # ამ განცხადებით გათვალიწინებული ყველა სამუშაო
  field :plan_end_date, type: Date
  field :end_date, type: Date

  embeds_many :items, class_name: 'Network::NewCustomerItem', inverse_of: :application
  has_many :files, class_name: 'Sys::File', inverse_of: 'mountable'
  has_many :messages, class_name: 'Sys::SmsMessage', as: 'messageable'
  validates :user, presence: { message: 'user required' }
  validates :rs_tin, presence: { message: I18n.t('models.network_new_customer_application.errors.tin_required') }
  validates :mobile, presence: { message: I18n.t('models.network_new_customer_application.errors.mobile_required') }
  validates :email, presence: { message: I18n.t('models.network_new_customer_application.errors.email_required') }
  validates :address, presence: { message: I18n.t('models.network_new_customer_application.errors.address_required') }
  validates :address_code, presence: { message: I18n.t('models.network_new_customer_application.errors.address_code_required') }
  validates :bank_code, presence: { message: I18n.t('models.network_new_customer_application.errors.bank_code_required') }
  validates :bank_account, presence: { message: I18n.t('models.network_new_customer_application.errors.bank_account_required') }
  validates :voltage, presence: { message: 'required!' }
  validates :power, numericality: { message: I18n.t('models.network_new_customer_item.errors.illegal_power') }
  validate :validate_rs_name
  before_create :assign_number
  before_update :status_manager
  before_save :calculate!

  def calculate!
    tariff = Network::NewCustomerTariff.tariff_for(self.voltage, self.power)
    if tariff
      if power > 0
        tariff_days = self.need_resolution ? tariff.days_to_complete : tariff.days_to_complete_without_resolution
        self.amount = tariff.price_gel
        self.days = tariff_days
      end
    else
      if power > 0
        self.amount = nil
        self.days = nil
      end
    end
  end

  def billing_items
    if @__billing_items
      @__billing_items
    else
      customer_ids = items.map{ |x| x.customer_id }.select{ |x| x.present? }
      @__billing_items = Billing::Item.where('custkey IN ?', customer_ids).order('itemkey DESC')
    end
  end

  def customer; Billing::Customer.find(self.customer_id) if self.customer_id.present? end
  def unit
    if self.voltage == '6/10' then I18n.t('models.network_new_customer_item.unit_kvolt')
    else I18n.t('models.network_new_customer_item.unit_volt') end
  end
  def payments; self.billing_items.select { |x| x.billoperkey == 116 } end
  def paid; self.payments.map{ |x| x.amount }.inject{ |sum, x| sum + x } || 0  end
  def remaining; if self.amount.present? then self.amount - self.paid else 0 end end
  def self.status_name(status); I18n.t("models.network_new_customer_application.status_#{status}") end
  def self.status_icon(status)
    case status
    # when STATUS_DEFAULT    then '/icons/mail-open.png'
    when STATUS_SENT       then '/icons/mail-send.png'
    when STATUS_CANCELED   then '/icons/cross.png'
    when STATUS_CONFIRMED  then '/icons/clock.png'
    when STATUS_COMPLETE   then '/icons/tick.png'
    when STATUS_IN_BS      then '/icons/lock.png'
    else '/icons/mail-open.png'
    end
  end
  def status_name; Network::NewCustomerApplication.status_name(self.status) end
  def status_icon; Network::NewCustomerApplication.status_icon(self.status) end

  # შესაძლო სტატუსების ჩამონათვალი მიმდინარე სტატუსიდან.
  def transitions
    case self.status
    when STATUS_DEFAULT then [ STATUS_SENT, STATUS_CANCELED ]
    when STATUS_SENT then [ STATUS_DEFAULT, STATUS_CONFIRMED, STATUS_CANCELED ]
    when STATUS_CONFIRMED then [ STATUS_COMPLETE, STATUS_CANCELED ]
    else [ ]
    end
  end

  def calculate_distribution!
    # items = self.items.where(summary: false)
    # total_amount = (self.remaining * 100).to_i
    # if items.size > 0 and total_amount > 0
    #   per_item = total_amount / items.size
    #   remainder = total_amount - per_item * items.size
    #   items.each do |x|
    #     addition = 0
    #     addition = 1 and remainder -= 1 if remainder > 0
    #     x.amount = (per_item + addition) / 100.0
    #     x.save
    #   end
    # end
  end

  # ბილინგში გაგზავნა.
  def send_to_bs!
    # # --> შემოწმება, რომ ყველა აბონენტი დაკავშირებულია
    # items_without_customer = self.items.where(summary: false, customer_id: nil)
    # raise 'ყველა აბონენტი არაა გაწერილი ბილინგში' if items_without_customer.count > 0
    # # --> დავალიანების გადათვლა
    # self.calculate_distribution!
    # # --> გადანაწილება
    # Billing::Item.transaction do
    #   if self.items.count == 1
    #     item = self.items.first
    #     customer = item.customer
    #     account  = customer.accounts.first
    #     amount = self.amount
    #     # bs.item
    #     bs_item = Billing::Item.new(billoperkey: 1000, acckey: account.acckey, custkey: customer.custkey,
    #       perskey: 1, signkey: 1, itemdate: Date.today, reading: 0, kwt: 0, amount: amount,
    #       enterdate: Time.now, itemcatkey: 0)
    #     bs_item.save!
    #     # bs.customer update
    #     customer.except = 1
    #     customer.save!
    #     # bs.zdeposit_cust_qs
    #     network_customer = Billing::NetworkCustomer.where(customer: customer).first
    #     network_customer.exception_end_date = Date.today + 10
    #     network_customer.save!
    #     # bs.zdepozit_item_qs
    #     network_item = Billing::NetworkItem.new(zdepozit_cust_id: network_customer.zdepozit_cust_id, amount: amount,
    #       operkey: 1000, enterdate: Time.now, operdate: Date.today, perskey: 1)
    #     network_item.save!
    #   else
    #     raise 'ეს სიტუაცია ჯერ არაა მზად!'
    #   end
    # end
    # # update status
    # self.status = STATUS_IN_BS
    # self.save
  end

  private

  def assign_number; self.number = (Network::NewCustomerApplication.last.number + 1 rescue 1) end

  def validate_rs_name
    if self.rs_tin.present?
      self.rs_name = RS.get_name_from_tin(RS::SU.merge(tin: self.rs_tin))
      # self.vat_payer = RS.is_vat_payer(RS::SU)
      if self.rs_name.blank?
        errors.add(:rs_tin, I18n.t('models.network_new_customer_application.errors.tin_illegal'))
      end
    end
  end

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
end
