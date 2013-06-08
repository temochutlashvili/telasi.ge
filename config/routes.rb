# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
  def site_routes(parent, names = [])
    scope "/#{parent}", controller: parent do
      if names.any?
        get '/', to: redirect("/site/#{parent}/#{names.first}")
        names.each do |name|
          get "/#{name}", action: name, as: "#{parent}_#{name}"
        end
      else
        get '/', action: 'index', as: parent
      end
    end
  end

  namespace 'site' do
    get '/', to: redirect('/site/home')
    site_routes('home')
    site_routes('about', [ 'mission', 'history', 'law', 'structure', 'internals', 'management' ])
    site_routes('investors', [ 'capital', 'essentials', 'registration', 'reports', 'auditoring', 'notifications' ])
    site_routes('customers')
    site_routes('tenders')
    site_routes('contact')
  end

  root to: redirect('/site/home')
end
