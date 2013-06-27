# -*- encoding : utf-8 -*-
class Billing::Customer < ActiveRecord::Base
  ACTIVE = 0
  INACTIVE = 1
  CLOSED = 2

  self.table_name  = 'bs.customer'
  self.primary_key = :custkey

  belongs_to :address,      class_name: 'Billing::Address',       foreign_key: :premisekey
  belongs_to :send_address, class_name: 'Billing::Address',       foreign_key: :sendkey
  has_one  :trash_customer, class_name: 'Billing::TrashCustomer', foreign_key: :custkey
  has_many :water_items,    class_name: 'Billing::WaterItem',     foreign_key: :custkey, order: 'year, month'
  has_many :item_bills,     class_name: 'Billing::ItemBill',      foreign_key: :custkey, order: 'itemkey'
  has_many :accounts,       class_name: 'Billing::Account',       foreign_key: :custkey
  has_one  :note,           class_name: 'Billing::Note',          foreign_key: :notekey
  belongs_to :category,     class_name: 'Billing::Custcateg',     foreign_key: :custcatkey
  belongs_to :activity,     class_name: 'Billing::Custcateg',     foreign_key: :activity

  def region; self.address.region end
  def last_water_item; self.water_items.last end
  def water_balance; self.last_water_item.new_balance rescue 0 end
  def current_water_balance; self.last_water_item.curr_charge rescue 0 end
  def last_bill_date; self.item_bills.last.billdate end
  def last_bill_number; self.item_bills.last.billnumber end

  def pre_payment
    Billing::Payment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) { |sum, payment| sum += payment.amount }
  end

  def pre_payment_date
    Billing::Payment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).order('paykey desc').first.paydate rescue nil
  end

  # def pre_water_payment
  #   Bs::WaterPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) do |sum, payment|
  #     sum += payment.amount
  #   end
  # end

  # def pre_water_payment_date
  #   p = Bs::WaterPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).order('paykey desc').first
  #   p.paydate if p
  # end

  # def cut_candidate?
  #   self.normal_balance > 0.50 or self.normal_trash_balance > 0.50 or self.normal_water_balance > 0.50
  # end

  def status_name
    case self.statuskey
    when ACTIVE then I18n.t('models.bs.customer.statuses.active')
    when INACTIVE then I18n.t('models.bs.customer.statuses.inactive')
    when CLOSED then I18n.t('models.bs.customer.statuses.closed')
    else '?'
    end
  end
end
