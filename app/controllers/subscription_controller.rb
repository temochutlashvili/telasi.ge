# -*- encoding : utf-8 -*-
class SubscriptionController < ApplicationController
  def subscribe
    @title = I18n.t('models.sys_subscription.actions.subscribe')
    if request.get?
      if current_user
        @subscription = current_user.subscription || Sys::Subscription.new(email: current_user.email)
      else
        @subscription = Sys::Subscription.new
      end
    else
      subs_params = params[:sys_subscription]
      @subscription = Sys::Subscription.where(email: subs_params[:email]).first || Sys::Subscription.new(email: subs_params[:email])
      @subscription.company_news = subs_params[:company_news]
      @subscription.procurement_news = subs_params[:procurement_news]
      @subscription.outage_news = subs_params[:outage_news]
      if @subscription.save
        redirect_to subscribe_complete_url
      end
    end
  end

  def subscribe_complete
    @title = I18n.t('models.sys_subscription.actions.subscribe_complete')
  end
end
