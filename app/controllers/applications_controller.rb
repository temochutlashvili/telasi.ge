# -*- encoding : utf-8 -*-
class ApplicationsController < ApplicationController
  before_action :nav

  def index
    @title = I18n.t('menu.applications_alt')
  end

  protected

  def nav; end
end
