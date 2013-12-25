# -*- encoding : utf-8 -*-
class Site::Node < ActiveRecord::Base
  self.table_name  = 'telasi.node'
  self.primary_key = :nid
  self.inheritance_column = :inheritance_column

  def created_at; Time.at(self.created) end
  def updated_at; Time.at(self.updated) end

  def content_type
    Site::ContentType.where(entity_type: 'node', bundle: self.type, entity_id: self.nid).first
  end
end
