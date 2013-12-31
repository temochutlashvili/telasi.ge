# -*- encoding : utf-8 -*-
class Site::ContentThumbnail < ActiveRecord::Base
  self.table_name  = 'telasi.field_data_field_thumbnail'

  def file; Site::File.where(fid: self.field_thumbnail_fid).first end
end
