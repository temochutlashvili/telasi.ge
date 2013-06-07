class Site::BaseController < ApplicationController
  layout 'site'
  def index
    @title = I18n.t('site.index.title')
  end
end
