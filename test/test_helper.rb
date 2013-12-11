# -*- encoding : utf-8 -*-
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'rs'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  def make_clear_state
    Mongoid.purge!
    ActionMailer::Base.deliveries.clear
    RS.update_user(username: 'tbilisi', password: '123456', ip: RS.what_is_my_ip, su: 'DIMITRI1979:206322102', sp: '123456', name: 'telasi.ge')
  end
end
