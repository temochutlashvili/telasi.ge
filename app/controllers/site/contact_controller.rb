# -*- encoding : utf-8 -*-
class Site::ContactController < Site::SiteController
  def index
    @title = I18n.t('site.pages.contact.title')
  end
end
