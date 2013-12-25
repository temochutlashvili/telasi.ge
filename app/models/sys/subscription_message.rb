# -*- encoding : utf-8 -*-
class Sys::SubscriptionMessage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :nid, type: Integer

  field :message_type, type: String
  field :subject, type: String
  field :body, type: String
  field :sent, type: Mongoid::Boolean, default: false
  field :locale, type: String
  field :date, type: Date

  def subscirption; Sys::Subscription.where(email: self.email).first end
  def node; Site::Node.find(self.nid) end

  def self.generate_subscription_messages
    last_nid = Sys::SubscriptionMessage.last.nid rescue 0
    news = Site::Node.where('type = ? AND nid > ? AND created > ?', 'news', last_nid, (Time.now - 1.days).to_i)
    news.each do |headline|
      headline_type = headline.content_type.field_content_type_value
      Sys::Subscription.each do |subscription|
        if subscription.belong_to_type(headline_type) and headline.language == subscription.locale
          m = Sys::SubscriptionMessage.new(email: subscription.email, nid: headline.nid, message_type: headline_type,
            subject: headline.title, body: headline.content.body_value, locale: headline.language, date: headline.created_at)
          m.save
        end
      end
    end
  end
end
