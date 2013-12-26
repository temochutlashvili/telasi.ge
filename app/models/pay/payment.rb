# -*- encoding : utf-8 -*-
class Pay::Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user, class_name: 'Sys::User'              # მომხმარებელი

  field :merchant, 	       type: String					         # მერჩანტის უნიკალური კოდი
  field :ordercode,        type: Integer					       # მერჩანტის ტრანზაქციის უნიკალური კოდი
  field :amount, 	         type: Float  					       # თანხა
  field :amount_tech,      type: Integer                 # თანხა თეტრებში
  field :currency,         type: String, default: 'GEL'  # ვალუტა GEL
  field :date,             type: DateTime                # თარიღი
  field :status,           type: String                  # სტატუსი
  field :transactioncode,  type: String                  # ტრანზაქციის კოდი
  field :paymethod,        type: String                  # გადახდის არხის სახელი
  field :description,      type: String					         # ოპერაციის აღწერა
  field :clientname,       type: String					         # კლიენტის სახელი
  field :ispreauth,        type: Integer					       # პრეაცვოიზაცია
  field :customdata,       type: String					         # დამატებითი მონაცემები
  field :lng,              type: String					         # ენა
  field :testmode,         type: Integer 				         # სატესტო რეჟიმი
  field :check,            type: String	 				         # საკონტროლო კოდი
  field :check_returned,   type: String                  # საკონტროლო კოდი
  field :check_callback,   type: String                  # საკონტროლო კოდი
  field :successurl,       type: String					         # წარმატებით დასრულებისას დებრუნების მისამართი
  field :errorurl,         type: String					         # შეცდომისას დასრულებისას დებრუნების მისამართი
  field :cancelurl,        type: String					         # შეწყვეტისას დასრულებისას დებრუნების მისამართი
  field :callbackurl,      type: String                  # გადახდის დადასტურების მისამართი
  field :itemN_name,       type: String					         # საქონლის ჩამონათვალი, დასახელება
  field :itemN_price,      type: String					         # საქონლის ჩამონათვალი, ფასი

  validates :merchant, presence: { message: 'ჩაწერეთ მერჩანტი' }
  validates :ordercode, presence: { message: 'ჩაწერეთ შეკვეთის კოდი' }
  validates :amount, numericality: { greater_than: 0, message: 'მნიშვნელობა უნდა იყოს 0-ზე მეტი' }

  validates :currency, presence: { message: 'currency not defined' }
  validates :lng, presence: { message: 'lng not defined' }
  validates :testmode, presence: { message: 'testmode not defined' }
  validates :check, presence: { message: 'check not defined' }

  before_save :calculate_tech_amount

  STATUS_COMPLETED = 'COMPLETED'
  STATUS_CANCELED  = 'CANCELED'
  STATUS_ERROR     = 'ERROR'

  private

  def calculate_tech_amount
    self.amount_tech = (self.amount * 100).round
  end
end
