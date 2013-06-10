# -*- encoding : utf-8 -*-
class Sys::FacebookAuth
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user, class_name: 'Sys::User'
  field :uid,   type: Integer
  field :email, type: String
  field :token, type: String
  field :expires_at, type: DateTime
  field :image, type: String

  def self.from_omniauth(auth)
    fb_user = where(user_id: auth.uid).first_or_initialize
    fb_user.uid = auth.uid
    fb_user.email = auth.info.email
    fb_user.token = auth.credentials.token
    fb_user.expires_at = Time.at(auth.credentials.expires_at)
    fb_user.image = auth.info.image
    if (fb_user.new_record?)
      user = Sys::User.new(first_name: auth.info.first_name, last_name: auth.info.last_name)
      user.save!
    else
      user = fb_user.user
      user.update_attributes!(first_name: auth.info.first_name, last_name: auth.info.last_name)
    end
    fb_user.user = user
    fb_user.save!
    user
  end
end
