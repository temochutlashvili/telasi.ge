# -*- encoding : utf-8 -*-
class Billing::CustomerRelation < ActiveRecord::Base
  self.table_name  = 'bs.custrel'

  def self.new_customer_application_subcustomers(customer)
    sub_customers = []
    Billing::CustomerRelation.where(base_custkey: customer.custkey, reltype: 2).each do |rel|
      sub_customers << Billing::Customer.find(rel.custkey)
    end
    sub_customers
  end
end
