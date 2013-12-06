# -*- encoding : utf-8 -*-
class Billing::AccountTariff < ActiveRecord::Base
  self.table_name  = 'bs.acctariffs'
  self.primary_key = :acctarkey
  belongs_to :account, class_name: 'Billing::Account', foreign_key: :acckey
  belongs_to :tariff, class_name: 'Billing::Tariff', foreign_key: :compkey
end