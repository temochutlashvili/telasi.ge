# -*- encoding : utf-8 -*-
class Site::AboutController < Site::SiteController
  def index
    @title = I18n.t('site.pages.about.title')
  end

  def mission
    @title = I18n.t('site.pages.about.mission.title')
  end

  def history
    @title = I18n.t('site.pages.about.history.title')
  end

  def law
    @title = I18n.t('site.pages.about.law.title')
  end

  def structure
    @title = I18n.t('site.pages.about.structure.title')
  end

  def internals
    @title = I18n.t('site.pages.about.internals.title')
  end

  def management
    @title = I18n.t('site.pages.about.management.title')
  end
end
