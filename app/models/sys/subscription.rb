# -*- encoding : utf-8 -*-
class Sys::Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email,  type: String
  field :active,     type: Mongoid::Boolean, default: true
  field :company_news, type: Mongoid::Boolean, default: true
  field :procurement_news, type: Mongoid::Boolean, default: true
  field :outage_news, type: Mongoid::Boolean, default: true
  field :locale, type: String, default: 'ka'

  validates :email,
    uniqueness: { message: I18n.t('models.sys_subscription.errors.duplicated_email') },
    presence: { message: I18n.t('models.sys_subscription.errors.empty_email') }
  index({ email: 1 }, { unique: true })

  def user; Sys::User.where(email: self.email).first end
end
