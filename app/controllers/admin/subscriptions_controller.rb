# -*- encoding : utf-8 -*-
class Admin::SubscriptionsController < ApplicationController
  def index
    @title = I18n.t('applications.admin.subscriptions')
    @subscriptions = Sys::Subscription.desc(:_id).paginate(page: params[:page], per_page: 20)
  end
end
