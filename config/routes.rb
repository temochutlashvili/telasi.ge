# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
  scope controller: 'dashboard' do
    match '/login', action: 'login', as: 'login', via: ['get', 'post']
    get '/logout', action: 'logout', as: 'logout'
    match '/register', action: 'register', as: 'register', via: ['get', 'post']
    get '/register_complete', action: 'register_complete', as: 'register_complete'
    get '/confirm', action: 'confirm', as: 'confirm'
    match '/restore', action: 'restore', as: 'restore', via: ['get', 'post']
  end

  scope '/profile', controller: 'profile' do
    get '/', action: 'index', as: 'profile'
    match '/edit', action: 'edit', as: 'edit_profile', via: ['get', 'put']
    match '/change_password', action: 'change_password', as: 'change_password', via: ['get', 'post']
  end

  scope '/customers', controller: 'customers' do
    get '/', action: 'index', as: 'customers'
    get '/search', action: 'search', as: 'search_customer'
    match '/info/:custkey', action: 'info', as: 'customer_info', via: ['get', 'post']
    get '/complete/:custkey', action: 'complete', as: 'add_customer_complete'
  end

  scope '/applications', controller: 'applications' do
    get '/', action: 'index', as: 'applications'
  end

  namespace 'admin' do
    scope '/users', controller: 'users' do
      get '/', action: 'index', as: 'users'
      get '/show/:id', action: 'show', as: 'user'
      match '/edit/:id', action: 'edit', as: 'edit_user', via: ['get', 'post']
    end
    scope '/customers', controller: 'customers' do
      get '/', action: 'index', as: 'customers'
      get '/show/:id', action: 'show', as: 'show_customer'
      post '/confirm/:id', action: 'confirm', as: 'confirm_customer'
      match '/deny/:id', action: 'deny', as: 'deny_customer', via: ['get', 'post']
    end
  end

  root 'dashboard#index'
end
