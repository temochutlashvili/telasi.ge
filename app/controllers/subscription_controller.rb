# -*- encoding : utf-8 -*-
class SubscriptionController < ApplicationController
  def subscribe
    @title = I18n.t('models.sys_subscription.actions.subscribe')
    if current_user
      @subscription = current_user.subscription || Sys::Subscription.new(email: current_user.email)
    else
      @subscription = Sys::Subscription.new unless @subscription.present?
    end
    unless request.get?
      @subscription.save
      @subscription.update_attributes(params.require(:sys_subscription).permit(:email, :company_news, :procurement_news, :outage_news))

    end
  end
end
