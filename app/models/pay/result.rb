# -*- encoding : utf-8 -*-
class Pay::Result
  include Mongoid::Document

  field :resultcode,       type: Integer
  field :resultdesc,       type: String	
  field :check,            type: String
  field :data,             type: String
end
