# -*- encoding : utf-8 -*-
class Network::RequestItem
  include Mongoid::Document
  include Mongoid::Timestamps

  IN = 1   # incoming request
  OUT = 2  # outgoing request

  belongs_to :stage, class_name: 'Network::Stage'
  belongs_to :source, polymorphic: true
  field :date, type: Date
  field :type, type: Integer
  field :description, type: String
  validates :stage, presence: { message: 'აარჩიეთ ეტაპი' }
  validates :date, presence: { message: 'ჩაწერეთ თარიღი' }
  validates :type, presence: { message: 'აარჩიეთ სახეობა' }
  validates :description, presence: { message: 'ჩაწერეთ აღწერილობა' }

  def self.type_name(type); type == IN ? 'შემომავალი' : 'გამავალი' end
  def type_name; Network::RequestItem.type_name(self.type) end
end
