# -*- encoding : utf-8 -*-
require 'test_helper'

class Network::CalculationUtilsTest < ActiveSupport::TestCase
  include Network::CalculationUtils

  test "10 GEL / 3" do
    items = [''] * 3
    items2 = []
    distribute(items, 10) do |item, amnt|
      items2 << amnt
    end
    assert_equal 3, items2.size
    assert_equal 3.33, items2[0]
    assert_equal 3.33, items2[1]
    assert_equal 3.34, items2[2]
  end

  test "10.1 GEL / 3" do
    items = [''] * 3
    items2 = []
    distribute(items, 10.01) do |item, amnt|
      items2 << amnt
    end
    assert_equal 3, items2.size
    assert_equal 3.33, items2[0]
    assert_equal 3.34, items2[1]
    assert_equal 3.34, items2[2]
  end
end
