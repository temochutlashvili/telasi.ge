# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
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

  # Auth
  scope '/auth', controller: 'sessions' do
    match '/login', action: 'login', as: 'login', via: ['get', 'post']
    match '/register', action: 'register', as: 'register', via: ['get', 'post']
    match '/signout', to: 'sessions#destroy', as: 'signout', via: ['get', 'post', 'put']
    # facebook API
    # match '/:provider/callback', to: 'sessions#create', via: ['get', 'post', 'put']
    # match '/failure', to: redirect('/'), via: ['get', 'post', 'put']
  end

  # Dashboard.
  namespace 'user' do
    get '/', to: redirect('/user/dashboard')
    scope '/dashboard', controller: 'dashboard' do
      get '/', action: 'index', as: 'dashboard'
    end
    scope '/customer', controller: 'customer' do
      get '/', action: 'index', as: 'customer'
    end
  end

  # Admin.
  namespace 'admin' do
    get '/', controller: 'base', action: 'index', as: 'home'
    scope '/users', controller: 'users' do
      get '/', action: 'index', as: 'users'
      get '/show/:id', action: 'show', as: 'user'
    end
  end

  root to: redirect('/site/home')
end
