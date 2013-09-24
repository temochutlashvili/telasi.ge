# -*- encoding : utf-8 -*-
class Billing::Aviso < ActiveRecord::Base
  self.table_name  = 'payments.avizo_detail'
  self.primary_key = :avdetkey
  belongs_to :paypoint, class_name: 'Billing::Paypoint', foreign_key: 'basepointkey'
end
