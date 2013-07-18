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
  end

  scope '/applications', controller: 'applications' do
    get '/', action: 'index', as: 'applications'
  end

  namespace 'admin' do
    scope '/users', controller: 'users' do
      get '/', action: 'index', as: 'users'
    end
  end

  root 'dashboard#index'
end
