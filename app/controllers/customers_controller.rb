class CustomersController < ApplicationController
  before_action :validate_login, :nav

  def index
    @title = I18n.t('menu.customers')
  end

  protected

  def nav; end
end
