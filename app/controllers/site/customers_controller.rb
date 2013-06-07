# -*- encoding : utf-8 -*-
class Site::CustomersController < Site::SiteController
  def index
    @title = I18n.t('site.pages.customers.title')
  end
end
