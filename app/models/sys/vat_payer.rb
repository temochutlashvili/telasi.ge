# -*- encoding : utf-8 -*-
module Sys::VatPayer
  NOT_PAYER  = 0 # არ-გადამხდელი    --> არ ეგზავნება
  PAYER      = 1 # გადამხდელი       --> ეგზავნება
  PAYER_ZERO = 2 # განთავისუფლებული --> ნულოვანი დღგ 

  def self.included(base)
    base.field :vat_payer, type: Boolean, default: true
    base.field :vat_zero,  type: Boolean, default: false
  end

  def vat_options
    if not self.vat_payer then NOT_PAYER
    elsif not self.vat_zero then PAYER
    else PAYER_ZERO end
  end

  def vat_options=(opts)
    if opts.to_i == NOT_PAYER
      self.vat_payer = false
      self.vat_zero  = false
    elsif opts.to_i == PAYER
      self.vat_payer = true
      self.vat_zero  = false
    else
      self.vat_payer = true
      self.vat_zero  = true
    end
  end

  def self.vat_name(option)
    case option
    when NOT_PAYER then 'არაა გადამხდელი'
    when PAYER then 'გადამხდელი'
    when PAYER_ZERO then 'განთავისუფლებული'
    end
  end

  def vat_name; Sys::VatPayer.vat_name(self.vat_options) end

  def vat_payer?; self.vat_payer end
  def pays_non_zero_vat?; not self.vat_zero end
end
