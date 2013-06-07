class Site::BaseController < ApplicationController
  def index
    @title = I18n.t('site.index.title')
  end
end
