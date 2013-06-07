# -*- encoding : utf-8 -*-
class Site::AboutController < Site::SiteController
  def index
    @title = I18n.t('site.pages.about.title')
  end
end
