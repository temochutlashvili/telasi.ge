class Billing::CustomerRegistration
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, class_name: 'Sys::User'
  field :custkey, type: Integer
  field :rs_tin, type: String
  field :rs_name, type: String
  field :confirmed, type: Mongoid::Boolean
end
