# -*- encoding : utf-8 -*-
class Billing::Tariff < ActiveRecord::Base
  self.table_name  = 'bs.tarcomp'
  self.primary_key = :compkey
  has_many :steps, class_name: 'Billing::TariffStep', foreign_key: :ts_tar_key, order: :ts_seq
end
