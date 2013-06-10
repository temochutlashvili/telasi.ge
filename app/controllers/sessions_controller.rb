# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  def create
    # user = User.from_omniauth(env["omniauth.auth"])
    # session[:user_id] = user.id
    # redirect_to root_url
    render text: env["omniauth.auth"]
  end
end
