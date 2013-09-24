# -*- encoding : utf-8 -*-
class Network::ChangePowerController < Admin::AdminController
  layout 'one_column'

  def index
    @title = 'განცხადებები'
  end

  def new
    @title = 'ახალი განცხადება'
    @application = Network::ChangePowerApplication.new
  end

  protected

  def nav
    @nav = { 'ქსელი' => network_home_url, 'სიმძლავრის შეცვლა' => network_change_power_applications_url }
    if @application
      if not @application.new_record?
        @nav[ "№#{@application.number}" ] = network_change_power_url(id: @application.id)
        @nav[@title] = nil if action_name != 'new'
      else
        @nav['ახალი განცხადება'] = nil
      end
    end
    @nav
  end
end
