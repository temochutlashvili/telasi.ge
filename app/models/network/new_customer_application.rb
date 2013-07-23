# -*- encoding : utf-8 -*-
class Network::NewCustomerApplication
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user, class_name: 'Sys::User'
  field :rs_tin,    type: String
  field :rs_name,   type: String
  field :vat_payer, type: Mongoid::Boolean
  field :mobile,    type: String
  field :email,     type: String
  field :address,   type: String
  field :bank_code,    type: String
  field :bank_account, type: String
end
