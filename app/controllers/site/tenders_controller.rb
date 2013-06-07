# -*- encoding : utf-8 -*-
class Site::TendersController < Site::SiteController
  def index
    @title = I18n.t('site.pages.tenders.title')
  end
end
