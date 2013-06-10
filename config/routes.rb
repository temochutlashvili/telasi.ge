# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
  # facebook API
  match '/auth/:provider/callback', to: 'sessions#create', via: ['get', 'post', 'put']
  match '/auth/failure', to: redirect('/'), via: ['get', 'post', 'put']
  match '/signout', to: 'sessions#destroy', as: 'signout', via: ['get', 'post', 'put']

  # Site namespace
  namespace 'site' do
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

    get '/', to: redirect('/site/home')
    site_routes('home')
    site_routes('about', [ 'mission', 'history', 'law', 'structure', 'internals', 'management' ])
    site_routes('investors', [ 'capital', 'essentials', 'registration', 'reports', 'auditoring', 'notifications' ])
    site_routes('customers')
    site_routes('tenders')
    site_routes('contact')
  end

  # User dashboard.
  namespace 'user' do
    scope '/dashboard', controller: 'dashboard' do
      get '/', action: 'index'
    end
  end

  root to: redirect('/site/home')
end
