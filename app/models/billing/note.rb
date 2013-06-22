# -*- encoding : utf-8 -*-
class Billing::Note < ActiveRecord::Base
  self.table_name  = 'bs.notes'
  self.primary_key = :notekey

  def to_s
    self.note.to_ka if self.note
  end
end
