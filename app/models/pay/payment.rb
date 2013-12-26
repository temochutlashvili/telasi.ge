# -*- encoding : utf-8 -*-
class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :userid,           type: String                  # მომხმარებელის ID
  field :merchant, 	       type: String					         # მერჩანტის უნიკალური კოდი
  field :ordercode,        type: Integer					       # მერჩანტის ტრანზაქციის უნიკალური კოდი
  field :amount, 	         type: Float  					       # თანხა
  field :amount_tech,      type: Integer                 # თანხა თეტრებში
  field :currency,         type: String                  # ვალუტა GEL
  field :date,             type: DateTime                # თარიღი
  field :status,           type: String                  # თარიღი
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

  validates_presence_of :merchant
  validates_presence_of :ordercode
  validates_numericality_of :amount, :greater_than => 0, :message => 'მნიშვნელობა უნდა იყოს 0-ზე მეტი' #'Must be greater then 0'
#  validates_presence_of :currency
#  validates_presence_of :lng
#  validates_presence_of :testmode
#  validates_presence_of :check
  
  STATUS_COMPLETED = 'COMPLETED'
  STATUS_CANCELED  = 'CANCELED'
  STATUS_ERROR     = 'ERROR'
end
