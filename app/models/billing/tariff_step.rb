# -*- encoding : utf-8 -*-
class Billing::TariffStep < ActiveRecord::Base
  self.table_name  = 'bs.tariff_step'
  self.primary_key = :ts_key
  belongs_to :tariff, class_name: 'Billing::Tariff', foreign_key: :ts_tar_key
end
