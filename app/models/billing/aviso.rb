# -*- encoding : utf-8 -*-
class Billing::Aviso < ActiveRecord::Base
  self.table_name  = 'payments.avizo_detail'
  self.primary_key = :avdetkey
  belongs_to :paypoint, class_name: 'Billing::Paypoint', foreign_key: 'basepointkey'

  def related_application
    unless @__related_initialized
      @__related ||= Network::NewCustomerApplication.where(aviso_id: self.avdetkey).first
      @__related_initialized = true
    end
    @__related
  end

  def guessed_application
    if self.invoice and self.invoice[0] == 'C'
      related = Network::NewCustomerApplication.where(number: self.invoice, aviso_id: nil)
    else
     related = Network::NewCustomerApplication.where(payment_id: self.invoice, aviso_id: nil)
    end
    if related.count > 1
      filtered = related.where(rs_tin: self.taxid)
      if filtered.any? then filtered.first
      else related.first end
    elsif related.count == 1
      related.first
    end
  end
end
