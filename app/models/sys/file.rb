# -*- encoding : utf-8 -*-
class Sys::File
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :mountable, polymorphic: true
  mount_uploader :file, TelasiUploader
end
