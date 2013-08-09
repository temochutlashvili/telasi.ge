# -*- encoding : utf-8 -*-
class Sys::SmsMessage
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :messageable, polymorphic: true
  field :mobile, type: String
  field :message, type: String
  validates :message, presence: { message: 'ჩაწერეთ შინაარსი.' }
end
