# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  def create
    if params[:provider] == 'facebook'
      user = Sys::FacebookAuth.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_url
    end
    # user = User.from_omniauth(env["omniauth.auth"])
    # session[:user_id] = user.id
    # redirect_to root_url
    # auth = env["omniauth.auth"]
    # render text: auth.uid
    # render text: params[:provider]
  end
end
