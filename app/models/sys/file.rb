# -*- encoding : utf-8 -*-
class Sys::File
  include Mongoid::Document
  include Mongoid::Timestamps
  mount_uploader :avatar, AvatarUploader
end
