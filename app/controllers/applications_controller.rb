class ApplicationsController < ApplicationController
  before_action :validate_login, :nav

  def index
    @title = I18n.t('menu.applications_alt')
  end

  protected

  def nav; end
end
