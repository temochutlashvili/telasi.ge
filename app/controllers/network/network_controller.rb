# -*- encoding : utf-8 -*-
class Network::NetworkController < ApplicationController
  before_action :validate_login
  before_action :validate_network_admin

  private

  def validate_network_admin
    unless current_user.network_admin?
      redirect_to login_url, alert: 'საჭიროა იყოთ ქსელის ამინისტრატორი!'
    end
  end
end
