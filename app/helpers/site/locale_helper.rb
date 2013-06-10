# -*- encoding : utf-8 -*-
require 'uri'

module Site::LocaleHelper
  def locale_url(lang)
    uri =  URI.parse(request.url)
    query = URI.decode_www_form(uri.query) rescue []
    index = query.index { |x| x[0] == 'locale' }
    query.delete_at index if index
    query << ['locale', lang]
    uri.query = URI.encode_www_form(query)
    uri.to_s
  end
end
