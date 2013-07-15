# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
  scope controller: 'dashboard' do
    match '/login', action: 'login', as: 'login', via: ['get', 'post']
    match '/register', action: 'register', as: 'register', via: ['get', 'post']
    match '/restore', action: 'restore', as: 'restore', via: ['get', 'post']
  end

  root 'dashboard#index'
end
