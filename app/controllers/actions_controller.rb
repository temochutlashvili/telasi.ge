# -*- encoding : utf-8 -*-
class ActionsController < ApplicationController
  before_action :validate_login

  # Rendering.
  def render(*args); nav; super end

  # Navigation.
  def nav; @nav = { I18n.t('dashboard.title_short') => user_dashboard_url } end
end
