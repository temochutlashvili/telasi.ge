# -*- encoding : utf-8 -*-
class Admin::SubscriptionsController < ApplicationController
  def index
    @title = I18n.t('applications.admin.subscriptions')
    @subscriptions = Sys::Subscription.desc(:_id).paginate(page: params[:page], per_page: 10)
    @news = Site::Node.where(type: 'news').order('nid DESC').paginate(page: params[:news_page], per_page: 10)
  end
end
