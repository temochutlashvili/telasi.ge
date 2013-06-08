# -*- encoding : utf-8 -*-
class Site::SiteController < ApplicationController
  layout 'site'

  def self.define_actions(parent, actions)
    actions.each do |a|
      if a.to_s == 'index'
        define_method(a) { instance_variable_set('@title', I18n.t("site.pages.#{parent}.title")) }
      else
        define_method(a) { instance_variable_set('@title', I18n.t("site.pages.#{parent}.#{a}.title")) }
      end
    end
  end
end
