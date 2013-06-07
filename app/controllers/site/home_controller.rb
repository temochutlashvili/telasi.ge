# -*- encoding : utf-8 -*-
class Site::HomeController < Site::SiteController
  def index
    @title = I18n.t('site.pages.home.title')
  end
end
