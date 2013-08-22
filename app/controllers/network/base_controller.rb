# -*- encoding : utf-8 -*-
class Network::BaseController < Admin::AdminController
  layout 'one_column'

  def index
    @title = 'ქსელი'
    @applications = Network::NewCustomerApplication.desc(:_id)
  end
end
