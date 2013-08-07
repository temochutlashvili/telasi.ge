# -*- encoding : utf-8 -*-
class Select::CustomerController < ApplicationController
  layout 'select'

  def index
    @title = 'აბონენტის არჩევა'
    @customers = Billing::Customer.paginate(per_page: 10, page: params[:page])
    # TODO: search
  end
end
