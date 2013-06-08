# -*- encoding : utf-8 -*-
class Site::InvestorsController < Site::SiteController
  def capital
    @title = I18n.t('site.pages.investors.capital.title')
  end
  def essentials
    @title = I18n.t('site.pages.investors.essentials.title')
  end
end
