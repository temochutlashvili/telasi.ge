# -*- encoding : utf-8 -*-
class Sys::SmsMessage
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :messageable, polymorphic: true
  field :mobile, type: String
  field :message, type: String
  field :sent, type: Mongoid::Boolean, default: false
  validate :message, presence: { message: 'ჩაწერეთ განმარტება.' }
end
