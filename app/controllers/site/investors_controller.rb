# -*- encoding : utf-8 -*-
class Site::InvestorsController < Site::SiteController
  def index
    @title = I18n.t('site.pages.investors.title')
  end
end
