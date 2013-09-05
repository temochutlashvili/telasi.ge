# -*- encoding : utf-8 -*-
module BanksHelper
  def banks; Hash[Bank::BANKS.map{|k,v| ["#{k} &mdash; #{v}".html_safe,k]}] end
end
