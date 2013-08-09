# -*- encoding : utf-8 -*-
class Sys::SmsMessage
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :messageable, polymorphic: true
  field :mobile, type: String
  field :message, type: String
  validates :message, presence: { message: 'ჩაწერეთ შინაარსი.' }

  def send_sms!
    Magti.send_sms(self.mobile, self.message[0..150].to_lat) if Magti::SEND
  end
end
