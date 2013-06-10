# -*- encoding : utf-8 -*-
class Sys::User
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :password_confirmation

  field :first_name, type: String
  field :last_name,  type: String
  field :mobile,     type: String
  field :sys_admin, type: Boolean

  validates :first_name, presence: { message: I18n.t('models.sys_user.errors.first_name_required') }
  validates :last_name,  presence: { message: I18n.t('models.sys_user.errors.last_name_required') }

  before_create :before_user_create
  before_update :before_user_update

  def full_name; "#{self.first_name} #{self.last_name}" end
  def to_s; self.full_name end
end
