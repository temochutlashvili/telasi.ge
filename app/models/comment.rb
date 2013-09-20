# -*- encoding : utf-8 -*-
class Comment
  include Mongoid::Document
  include Mongoid::Timestamps 
  belongs_to :commentable, polymorphic: true
  field :text, type: String
  validates :text, presence: { message: 'ჩაწერეთ შინაარსი.' }
end
