# -*- encoding : utf-8 -*-
class Sys::User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :first_name, type: String
  field :last_name,  type: String
  field :mobile,     type: String
  field :sys_admin,  type: Boolean
  has_one :facebook_auth, class_name: 'Sys::FacebookAuth'

  def full_name; "#{self.first_name} #{self.last_name}" end
  def to_s; self.full_name end
  def image; self.facebook_auth.image end
  def email; self.facebook_auth.email end
end
