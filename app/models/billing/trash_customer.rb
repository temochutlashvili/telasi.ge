# -*- encoding : utf-8 -*-
class Billing::TrashCustomer < ActiveRecord::Base
  ACTIVE       = 0
  INACTIVE     = 1
  CLOSED       = 2
  NOT_EXISTING = 3

  self.table_name  = 'bs.trashcustomer'
  self.primary_key = :custkey
  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
  belongs_to :note,     class_name: 'Billing::Note',     foreign_key: :note_id

  def pre_payment
    Billing::TrashPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) do |sum, payment|
      sum += payment.amount
    end
  end

  def pre_payment_date
    Billing::TrashPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).order('paykey desc').first.paydate rescue nil
  end

  # def status_name
  #   case self.status
  #   when ACTIVE then 'აქტიური'
  #   when INACTIVE then 'გაუქმებული'
  #   when CLOSED then 'დახურული'
  #   when NOT_EXISTING then 'არ არსებული'
  #   else '?'
  #   end
  # end
end
