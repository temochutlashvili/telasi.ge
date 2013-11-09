# -*- encoding : utf-8 -*-
require 'test_helper'

class Network::NewCustomerApplicationTest < ActiveSupport::TestCase
  test "number correctness" do
    assert Network::NewCustomerApplication.correct_number?("CNS-12/3456/78")
    assert Network::NewCustomerApplication.correct_number?("TCNS-12/3456/78")
    assert Network::NewCustomerApplication.correct_number?("1TCNS-12/3456/78")
    assert Network::NewCustomerApplication.correct_number?("3TCNS-12/3456/78")
    refute Network::NewCustomerApplication.correct_number?("CNS-12/3456/785")
  end
end
