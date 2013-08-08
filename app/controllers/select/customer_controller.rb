# -*- encoding : utf-8 -*-
class Select::CustomerController < ApplicationController
  layout 'select'

  def index
    @title = 'აბონენტის არჩევა'
    @search = params[:search] == 'clear' ? nil : params[:search]
    @customers = Billing::Customer
    if @search
      @customers = @customers.where('accnumb like ?', @search[:accnumb].likefy) if @search[:accnumb].present?
      @customers = @customers.where('custname like ?', @search[:custname].likefy.to_geo) if @search[:custname].present?
    end
    @customers = @customers.paginate(per_page: 10, page: params[:page])
  end
end
