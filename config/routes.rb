# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
  scope controller: 'dashboard' do
    match '/login', action: 'login', as: 'login', via: ['get', 'post']
    get '/logout', action: 'logout', as: 'logout'
    match '/register', action: 'register', as: 'register', via: ['get', 'post']
    get '/register_complete', action: 'register_complete', as: 'register_complete'
    get '/confirm', action: 'confirm', as: 'confirm'
    match '/restore', action: 'restore', as: 'restore', via: ['get', 'post']
    match '/restore_password', action: 'restore_password', as: 'restore_password', via: ['get', 'post']
  end

  scope '/profile', controller: 'profile' do
    get '/', action: 'index', as: 'profile'
    match '/edit', action: 'edit', as: 'edit_profile', via: ['get', 'patch']
    match '/change_password', action: 'change_password', as: 'change_password', via: ['get', 'post']
  end

  scope '/customers', controller: 'customers' do
    get '/', action: 'index', as: 'customers'
    get '/search', action: 'search', as: 'search_customer'
    match '/info/:custkey', action: 'info', as: 'customer_info', via: ['get', 'post']
    get '/complete/:custkey', action: 'complete', as: 'add_customer_complete'
    get '/history/:custkey', action: 'history', as: 'customer_history'
    get '/trash_history/:custkey', action: 'trash_history', as: 'customer_trash_history'
    delete '/remove/:id', action: 'remove', as: 'remove_customer'
  end

  scope '/calculator', controller: 'calculator' do
    get '/', action: 'index', as: 'calculator'
  end

  scope 'subscription', controller: 'subscription' do
    match '/subscribe', action: 'subscribe', as: 'subscribe', via: ['get', 'post', 'patch']
    get '/subscribe_complete', action: 'subscribe_complete', as: 'subscribe_complete'
    match '/unsubscribe', action: 'unsubscribe', as: 'unsubscribe', via: ['get', 'post', 'patch']
    get '/unsubscribe_complete', action: 'unsubscribe_complete', as: 'unsubscribe_complete'
  end

  scope '/new_customers', controller: 'new_customers' do
    get '/', action: 'index', as: 'new_customers'
    match '/new', action: 'new', as: 'create_new_customer', via: ['get', 'post']
    get '/show/:id', action: 'show', as: 'new_customer'
    get '/show/:id/items', action: 'items', as: 'new_customer_items'
    get '/show/:id/messages', action: 'messages', as: 'new_customer_messages'
    get '/show/:id/files', action: 'files', as: 'new_customer_files'
    match '/edit/:id', action: 'edit', as: 'edit_new_customer', via: ['get', 'patch']
    # get '/payments/:id', action: 'payments', as: 'new_customer_payments'
    # get '/accounts/:id', action: 'accounts', as: 'new_customer_accounts'
    # match '/accounts/:id/new', action: 'new_account', as: 'new_customer_new_account', via: ['get', 'post']
    # match '/accounts/:id/edit/:item_id', action: 'edit_account', as: 'new_customer_edit_account', via: ['get', 'put']
    # delete '/accounts/:id/delete/:item_id', action: 'delete_account', as: 'new_customer_delete_account'
    # get '/files/:id', action: 'files', as: 'new_customer_files'
    # match '/files/:id/upload', action: 'upload_file', as: 'new_customer_upload_file', via: ['get', 'post']
    # delete '/files/:id/delete/:file_id', action: 'delete_file', as: 'new_customer_delete_file'
  end

  namespace 'admin' do
    scope '/users', controller: 'users' do
      get '/', action: 'index', as: 'users'
      get '/show/:id', action: 'show', as: 'user'
      match '/new', action: 'new', as: 'new_user', via: ['get', 'post']
      match '/edit/:id', action: 'edit', as: 'edit_user', via: ['get', 'post']
      delete '/delete/:id', action: 'delete', as: 'delete_user'
    end
    scope '/customers', controller: 'customers' do
      get '/', action: 'index', as: 'customers'
      get '/show/:id', action: 'show', as: 'show_customer'
      get '/confirm/:id', action: 'confirm', as: 'confirm_customer'
      match '/deny/:id', action: 'deny', as: 'deny_customer', via: ['get', 'post']
      delete '/delete/:id', action: 'delete', as: 'delete_customer'
    end
    scope '/subscriptions', controller: 'subscriptions' do
      get '/', action: 'index', as: 'subscriptions'
      get '/headline/:id', action: 'headline', as: 'headline'
      post '/generate_messages', action: 'generate_messages'
      post '/send_messages', action: 'send_messages'
    end
    get '/network' => redirect('/network')
  end

  namespace 'network' do
    scope '/', controller: 'base' do
      get '/', action: 'index', as: 'home'
    end
    scope '/tariffs', controller: 'tariffs' do
      get '/', action: 'index', as: 'tariffs'
      get '/generate_tariffs', action: 'generate_tariffs', as: 'generate_network_tariffs'
    end
    scope '/aviso', controller: 'aviso' do
      get '/', action: 'index', as: 'avisos'
      get '/show/:id', action: 'show', as: 'aviso'
      post '/link/:id', action: 'link', as: 'link_aviso'
      delete '/delink/:id', action: 'delink', as: 'delink_aviso'
      match '/add_customer/:id', action: 'add_customer', as: 'add_aviso_customer', via: ['get', 'post']
      post '/sync', action: 'sync', as: 'sync_avisos'
    end
    scope '/new_customer', controller: 'new_customer' do
      get '/', action: 'index', as: 'new_customers'
      # application actions
      match '/new', action: 'add_new_customer', as: 'add_new_customer', via: ['get', 'post']
      get   '/:id', action: 'new_customer', as: 'new_customer'
      match '/edit/:id', action: 'edit_new_customer', as: 'edit_new_customer', via: ['get', 'post']
      delete '/delete/:id', action: 'delete_new_customer', as: 'delete_new_customer'
      post '/sync_customers/:id', action: 'sync_customers', as: 'new_customer_sync_customers'
      # status operations
      match '/change_status/:id', action: 'change_status', as: 'change_new_customer_status', via: ['get', 'post']
      match '/send_sms/:id', action: 'send_sms', as: 'send_new_customer_sms', via: ['get', 'post']
      # file operations
      match '/upload_file/:id', action: 'upload_file', as: 'upload_new_customer_file', via: ['get', 'post']
      delete '/delete_file/:id/:file_id', action: 'delete_file', as: 'delete_new_customer_file'
      # --> billing system
      post '/send_to_bs/:id', action: 'send_to_bs', as: 'new_customer_send_to_bs'
      # link customer
      match '/link_bs_customer/:id', action: 'link_bs_customer', as: 'link_bs_customer', via: ['get','post']
      delete '/remove_bs_customer/:id', action: 'remove_bs_customer', as: 'remove_bs_customer'
      # 
      match '/change_plan_date/:id', action: 'change_plan_date', as: 'change_plan_date', via: ['get','post']
      match '/change_real_date/:id', action: 'change_real_date', as: 'change_real_date', via: ['get','post']
      # print
      get '/paybill/:id', action: 'paybill', as: 'new_customer_paybill'
      get '/print/:id', action: 'print', as: 'new_customer_print'
      post '/send_factura/:id', action: 'send_factura', as: 'new_customer_send_factura'
      # control items
      match '/new_control_item/:id', action: 'new_control_item', as: 'new_customer_new_control_item', via: ['get','post']
      match '/edit_control_item/:id', action: 'edit_control_item', as: 'new_customer_edit_control_item', via: ['get','post']
      delete '/delete_control_item/:id', action: 'delete_control_item', as: 'new_customer_delete_control_item'
    end
    scope '/change_power', controller: 'change_power' do
      get '/', action: 'index', as: 'change_power_applications'
      match '/new', action: 'new', as: 'add_change_power', via: ['get', 'post']
      match '/edit/:id', action: 'edit', as: 'edit_change_power', via: ['get', 'post']
      get   '/:id', action: 'show', as: 'change_power'
      delete '/delete/:id', action: 'delete', as: 'delete_change_power'
      # status operations
      match '/change_status/:id', action: 'change_status', as: 'change_change_power_status', via: ['get', 'post']
      match '/send_sms/:id', action: 'send_sms', as: 'send_change_power_sms', via: ['get', 'post']
      # file operations
      match '/upload_file/:id', action: 'upload_file', as: 'upload_change_power_file', via: ['get', 'post']
      delete '/delete_file/:id/:file_id', action: 'delete_file', as: 'delete_change_power_file'
      # control items
      match '/new_control_item/:id', action: 'new_control_item', as: 'change_power_new_control_item', via: ['get','post']
      match '/edit_control_item/:id', action: 'edit_control_item', as: 'change_power_edit_control_item', via: ['get','post']
      delete '/delete_control_item/:id', action: 'delete_control_item', as: 'change_power_delete_control_item'
      # change amount manually
      match '/edit_amount/:id', action: 'edit_amount', as: 'change_power_edit_amount', via: ['get', 'post']
      # send factura
      post '/send_factura/:id', action: 'send_factura', as: 'change_power_send_factura'
    end
    scope '/stages', controller: 'stages' do
      get '/', action: 'index', as: 'stages'
      match '/new', action: 'new', as: 'new_stage', via: ['get', 'post']
      match '/edit/:id', action: 'edit', as: 'edit_stage', via: ['get', 'post']
      delete '/delete/:id', action: 'delete', as: 'delete_stage'
    end
  end

  namespace 'select' do
    scope 'customer', controller: 'customer' do
      get '/', action: 'index', as: 'customer'
    end
  end

  namespace 'api' do
    scope '/customers', controller: 'customers' do
      get '/tariffs', action: 'tariffs'
    end
  end

  namespace 'pay' do
    scope '/payment', controller: :payments do
      match '/show_form',    action: :show_form, via: [:get, :post]
      get '/confirm_form',   action: :confirm_form
      post '/confirm_form',  action: :confirm_form
      match '/success',      action: :success, via: [:get, :post]
      match '/cancel',       action: :cancel, via: [:get, :post]
      match '/error',        action: :error, via: [:get, :post]
      get   '/callback',     action: :callback
      get   '/services',     action: :services
      get   '',              action: :index
      get   '/user_index',   action: :user_index
      get   '/delete',       action: :delete_all
    end  
  end

  root 'dashboard#index'
end
