# -*- encoding : utf-8 -*-
class Admin::SubscriptionsController < ApplicationController
  def index
    @subscriptions = Sys::Subscription.desc(:_id).paginate(page: params[:page], per_page: 20)
  end
end
