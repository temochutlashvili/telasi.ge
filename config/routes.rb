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
    get '/history/:custkey', action: 'history', as: 'customer_history'
    get '/trash_history/:custkey', action: 'trash_history', as: 'customer_trash_history'
  end

  scope '/new_customer', controller: 'new_customer' do
    get '/', action: 'index', as: 'new_customer'
    match '/new', action: 'new', as: 'new_new_customer', via: ['get', 'post']
    get '/show/:id', action: 'show', as: 'show_new_customer'
    match '/edit/:id', action: 'edit', as: 'edit_new_customer', via: ['get', 'put']
    get '/payments/:id', action: 'payments', as: 'new_customer_payments'
    get '/accounts/:id', action: 'accounts', as: 'new_customer_accounts'
    match '/accounts/:id/new', action: 'new_account', as: 'new_customer_new_account', via: ['get', 'post']
    match '/accounts/:id/edit/:item_id', action: 'edit_account', as: 'new_customer_edit_account', via: ['get', 'put']
    delete '/accounts/:id/delete/:item_id', action: 'delete_account', as: 'new_customer_delete_account'
    get '/files/:id', action: 'files', as: 'new_customer_files'
    match '/files/:id/upload', action: 'upload_file', as: 'new_customer_upload_file', via: ['get', 'post']
    delete '/files/:id/delete/:file_id', action: 'delete_file', as: 'new_customer_delete_file'
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
      get '/confirm/:id', action: 'confirm', as: 'confirm_customer'
      match '/deny/:id', action: 'deny', as: 'deny_customer', via: ['get', 'post']
    end
    scope '/network', controller: 'network' do
      get '/', action: 'index', as: 'network'
      get '/generate_tariffs', action: 'generate_tariffs', as: 'generate_network_tariffs'
      scope '/new_customer' do
        match '/new', action: 'add_new_customer', as: 'add_new_customer', via: ['get', 'post']
        match '/edut/:id', action: 'edit_new_customer', as: 'edit_new_customer', via: ['get', 'post']
        get   '/:id', action: 'new_customer', as: 'new_customer'
        match '/add_account/:id', action: 'add_new_customer_account', as: 'add_new_customer_account', via: ['get', 'post']
        match '/edit_account/:app_id/:id', action: 'edit_new_customer_account', as: 'edit_new_customer_account', via: ['get', 'post']
        delete '/delete_account/:app_id/:id', action: 'delete_new_customer_account', as: 'delete_new_customer_account'
        match '/link_new_customer_account/:app_id/:id', action: 'link_new_customer_account', as: 'link_new_customer_account', via: ['get','post']
        delete '/remove_new_customer_account/:app_id/:id', action: 'remove_new_customer_account', as: 'remove_new_customer_account'
        match '/change_status/:id', action: 'change_status', as: 'change_new_customer_status', via: ['get', 'post']
      end
    end
  end

  namespace 'select' do
    scope 'customer', controller: 'customer' do
      get '/', action: 'index', as: 'customer'
    end
  end

  root 'dashboard#index'
end
