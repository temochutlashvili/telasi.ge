# -*- encoding : utf-8 -*-
class Sys::FacebookAuth
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: Integer
  field :email,   type: String
  field :token,   type: String
  field :expires_at, type: DateTime
end

# credentials {
#   expires = true
#   expires_at = 1376043991
#   token = "ABC..........."
# }
# extra = {
#   raw_info= {
#     email = "dimakura@gmail.com"
#     first_name = "Dimitri"
#     gender = "male"
#     id = "100004049125716"
#     last_name = "Kurashvili"
#     link = "http://www.facebook.com/dimjs"
#     locale = "en_US"
#     name = "Dimitri Kurashvili"
#     timezone = 4
#     updated_time = "2013-01-30T09:11:16+0000"
#     username = "dimjs"
#     verified = true
#   }
# }
# info = {
#   email = "dimakura@gmail.com"
#   first_name = "Dimitri"
#   image = "http://graph.facebook.com/100004049125716/picture?type=square"
#   last_name = "Kurashvili" 
#   name = "Dimitri Kurashvili"
#   nickname = "dimjs"
#   urls = { Facebook="http://www.facebook.com/dimjs" }
#   verified=true
# }
# provider = "facebook"
# uid = "100004049125716"