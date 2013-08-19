# -*- encoding : utf-8 -*-
class Billing::Item < ActiveRecord::Base
  self.table_name    = 'bs.item'
  self.primary_key   = 'itemkey'
  self.sequence_name = 'bs.item_seq'

  belongs_to :customer,  class_name: 'Billing::Customer', foreign_key: :custkey
  belongs_to :account,   class_name: 'Billing::Account',  foreign_key: :acckey
  belongs_to :operation, class_name: 'Billing::Billoperation', foreign_key: :billoperkey
  belongs_to :person,    class_name: 'Billing::Person', foreign_key: :perskey
  belongs_to :signee,    class_name: 'Billing::Person', foreign_key: :signkey
  has_one    :note,      class_name: 'Billing::Note',   foreign_key: :notekey

  def cycle?; !self.schedkey.nil? end
end
