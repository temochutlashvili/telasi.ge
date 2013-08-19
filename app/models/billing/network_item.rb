# -*- encoding : utf-8 -*-
class Billing::NetworkItem < ActiveRecord::Base
  self.table_name  = 'bs.zdepozit_item_qs'
  self.primary_key = 'zdepozit_item_id'
  self.sequence_name = 'BS.ZDEPOZIT_ITEM_QS_ID_SEQ'

  belongs_to :customer, class_name: 'Billing::Customer', foreign_key: :custkey
end
