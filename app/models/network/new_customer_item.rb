# -*- encoding : utf-8 -*-
class Network::NewCustomerItem
  USE_PERSONAL     = 0
  USE_NOT_PERSONAL = 1
  USE_SHARED       = 2
  include Mongoid::Document
  include Mongoid::Timestamps

  field :summary, type: Mongoid::Boolean
  field :address,      type: String
  field :address_code, type: String
  field :voltage, type: String
  field :power,   type: Float
  field :use,     type: Integer, default: USE_PERSONAL
  field :count,   type: Integer
  field :rs_tin,  type: String
  field :rs_name, type: String
  field :comment, type: String
  embedded_in :application, class_name: 'Network::NewCustomerApplication', inverse_of: :items

  def unit
    if self.voltage == '6/10' then I18n.t('models.network_new_customer_item.unit_kvolt')
    else I18n.t('models.network_new_customer_item.unit_volt') end
  end

  def summary?; self.summary end
  def personal?; not self.summary end

  # validates_presence_of :type
  # validates_presence_of :address, message: 'ჩაწერეთ მისამართი.'
  # validates_presence_of :address_code, message: 'ჩაწერეთ საკადასტრო კოდი.'
  # validates_presence_of :voltage
  # validates_numericality_of :power, message: 'ჩაწერეთ სწორი რიცხვითი მნიშვნელობა.'

  # validate :validate_type
  # validate :validate_power
  # before_save :on_before_save

  private

  # def validate_type
  #   if self.type == TYPE_DETAIL
  #     errors.add(:tin, 'ჩაწერეთ საიდენტიფიკაციო ნომერი') if self.tin.blank?
  #   end
  # end

  # def validate_power
  #   errors.add(:power, 'სიმძლავრე უნდა იყოს მეტი 0-ზე.') if self.power.nil? or self.power <= 0
  # end

  # def on_before_save
  #   if self.type == TYPE_DETAIL
  #     self.count = 0
  #   else
  #     self.tin = nil
  #     self.name = nil
  #     self.count = 1 if self.count.nil? or self.count <= 0
  #   end
  # end
end
