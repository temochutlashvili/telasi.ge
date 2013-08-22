# -*- encoding : utf-8 -*-
module Network::NetworkHelper
  def new_customer_form(application, opts = {})
    forma_for application, title: opts[:title], collapsible: true, icon: opts[:icon] do |f|
      f.tab do |t|
        t.col1 do |c|
          c.text_field  :rs_tin,       required: true, autofocus: true
          c.text_field  :mobile,       required: true
          c.email_field :email,        required: true
          c.text_field  :address_code, required: true
          c.text_field  :address,      required: true, width: 300
          c.text_field  :bank_code,    required: true
          c.text_field  :bank_account, required: true, width: 300
        end
        t.col2 do |c|
          c.combo_field :voltage, collection: voltage_collection, empty: false, required: true
          c.number_field :power, after: 'kWh', width: 100, required: true
          c.boolean_field :need_resolution, required: true
        end
        f.submit (opts[:submit] || opts[:title])
        f.bottom_action opts[:cancel_url], label: 'გაუქმება', icon: '/icons/cross.png'
      end
    end
  end

  def new_customer_view(application, opts = {})
    def selected_tab
      case params[:tab]
      when 'accounts' then 1
      when 'sms' then 2
      when 'operations' then 3
      when 'files' then 4
      when 'sys' then 5
      else 0 end
    end
    view_for application, title: "#{opts[:title]} &mdash; №#{application.number}".html_safe, collapsible: true, icon: '/icons/user.png', selected_tab: selected_tab do |f|
      f.title_action admin_delete_new_customer_url(id: application.id), label: 'განცხადების წაშლა', icon: '/icons/bin.png', method: 'delete', confirm: 'ნამდვვილად გინდათ ამ განცხადების წაშლა?'
      # 1. general
      f.tab title: 'ძირითადი', icon: '/icons/user.png' do |t|
        t.action admin_edit_new_customer_url(id: application.id), label: 'შეცვლა', icon: '/icons/pencil.png'
        application.transitions.each do |status|
          t.action admin_change_new_customer_status_url(id: application.id, status: status), label: Network::NewCustomerApplication.status_name(status), icon: Network::NewCustomerApplication.status_icon(status)
        end
        if application.status == Network::NewCustomerApplication::STATUS_COMPLETE
          t.action admin_new_customer_send_to_bs_url(id: application.id), label: 'ბილინგში გაგზავნა', icon: '/icons/wand.png', method: 'post', confirm: 'ნამდვილად გინდათ ბილინგში გაგზავნა?'
        end
        t.text_field :number, required: true, tag: 'code'
        t.complex_field i18n: 'status_name', required: true do |c|
          c.image_field :status_icon
          c.text_field :status_name
        end
        t.complex_field i18n: 'rs_name', required: true do |c|
          c.text_field :rs_tin, tag: 'code'
          c.text_field :rs_name, url: ->(x) { admin_new_customer_url(id: x.id) }
        end
        t.email_field :email, required: true
        t.text_field :mobile, required: true
        t.text_field :address, required: true, hint: 'განმცხადებლის მისამართი'
        t.complex_field label: 'საბანკო ანგარიში', required: true do |c|
          c.text_field :bank_code, tag: 'code'
          c.text_field :bank_account
        end
        t.complex_field label: 'ძაბვა / სიმძლავრე', required: true do |c|
          c.text_field :voltage, tag: 'code'
          c.text_field :unit, after: '/'
          c.number_field :power, after: 'კვტ'
        end
        t.boolean_field :need_resolution, required: true
        t.complex_field label: 'ბილინგის აბონენტი' do |c|
          c.text_field 'customer.accnumb', tag: 'code', empty: false
          c.text_field 'customer.custname' do |cust|
            cust.action admin_link_bs_customer_url(id: application.id), icon: '/icons/user--pencil.png'
            if application.customer_id.present?
              cust.action admin_remove_bs_customer_url(id: application.id), icon: '/icons/user--minus.png', method: 'delete', confirm: 'ნამდვილად გინდათ აბონენტის წაშლა?'
            end
          end
        end
        t.col2 do |c|
          c.number_field :amount, after: 'GEL'
          c.number_field :days, max_digits: 0, after: 'დღე'
          c.number_field :paid, after: 'GEL'
          c.number_field :remaining, after: 'GEL'
          c.date_field :send_date
          c.date_field :start_date
          c.date_field :end_date do |real|
            real.action admin_change_real_date_url(id: application.id), icon: '/icons/pencil.png' if application.end_date.present?
          end
          c.date_field :plan_end_date do |plan|
            plan.action admin_change_plan_date_url(id: application.id), icon: '/icons/pencil.png' if application.plan_end_date.present?
          end
        end
      end
      # 2. customers
      f.tab title: "აბონენტები &mdash; <strong>#{application.items.count}</strong>".html_safe, icon: '/icons/users.png' do |t|
        t.action admin_calculate_new_customer_distribution_url(id: application.id), label: 'ვალის განაწილება', icon: '/icons/wand.png', method: 'post'
        t.table_field :items, table: { title: 'აბონენტები', icon: '/icons/users.png' } do |items|
          items.table do |t|
            t.title_action admin_add_new_customer_account_url(id: application.id), label: 'აბონენტის დამატება', icon: '/icons/plus.png'
            t.item_action ->(x) { admin_edit_new_customer_account_url(app_id: application.id, id: x.id) }, icon: '/icons/pencil.png', tooltip: 'შეცვლა'
            t.item_action ->(x) { admin_delete_new_customer_account_url(app_id: application.id, id: x.id) }, icon: '/icons/bin.png', method: 'delete', confirm: 'ნამდვილად გინდათ ამ ანგარიშის შეცვლა?', tooltip: 'წაშლა'
            t.complex_field label: 'მისამართი' do |c|
              c.text_field :address_code, tag: 'code'
              c.text_field :address
            end
            t.complex_field label: 'აბონენტი' do |c|
              c.text_field :rs_tin, tag: 'code'
              c.text_field :rs_name, empty: false
            end
            t.complex_field label: 'ბილინგის აბონენტი' do |c|
              c.text_field 'customer.accnumb', tag: 'code'
              c.text_field 'customer.custname', empty: false
            end
            t.number_field :amount, after: 'GEL'
          end
        end
      end
      # 3. sms messages
      f.tab title: "SMS &mdash; <strong>#{application.messages.count}</strong>".html_safe, icon: '/icons/mobile-phone.png' do |t|
        t.table_field :messages, table: { title: 'SMS შეტყობინებები', icon: '/icons/mobile-phone.png' } do |sms|
          sms.table do |t|
            t.title_action admin_send_new_customer_sms_url(id: application.id), label: 'SMS გაგზავნა', icon: '/icons/balloon--plus.png'
            t.date_field :created_at, formatter: '%d-%b-%Y %H:%M:%S'
            t.text_field :mobile, tag: 'code'
            t.text_field :message
          end
        end
      end
      # 4. billing operations
      f.tab title: "ოპერაციები &mdash; <strong>#{application.billing_items.count}</strong>".html_safe, icon: '/icons/edit-list.png' do |t|
        t.table_field :billing_items, table: { title: 'ბილინგის ოპერაციები', icon: '/icons/edit-list.png' } do |operations|
          operations.table do |t|
            t.text_field 'customer.accnumb', tag: 'code', label: 'აბონენტი'
            t.date_field 'itemdate', label: 'თარიღი'
            t.complex_field label: 'ოპერაცია' do |c|
              c.text_field 'operation.billopername', after: '&mdash;'.html_safe
              c.text_field 'operation.billoperkey', class: 'muted'
            end
            t.number_field 'kwt', after: 'kWh', label: 'დარიცხვა'
            t.number_field 'amount', after: 'GEL', label: 'თანხა'
            t.number_field 'balance', after: 'GEL', label: 'ბალანსი'
          end
        end
      end
      # 5. files
      f.tab title: "ფაილები &mdash; <strong>#{application.files.count}</strong>".html_safe, icon: '/icons/book-open-text-image.png' do |t|
        t.table_field :files, table: { title: 'ფაილები', icon: '/icons/book-open-text-image.png' } do |files|
          files.table do |t|
            t.title_action admin_upload_new_customer_file_url(id: application.id), label: 'ახალი ფაილის ატვირთვა', icon: '/icons/upload-cloud.png'
            t.item_action ->(x) { admin_delete_new_customer_file_url(id: application.id, file_id: x.id) }, icon: '/icons/bin.png', confirm: 'ნამდვილად გინდათ ფაილის წაშლა?', method: 'delete'
            t.text_field 'file.filename', url: ->(x) { x.file.url }, label: 'ფაილი'
          end
        end
      end
      # 6. sys
      f.tab title: 'სისტემური', icon: '/icons/traffic-cone.png' do |t|
        t.complex_field label: 'მომხმარებელი', hint: 'მომხმარებელი, რომელმაც შექმნა ეს განცხადება', required: true do |c|
          c.email_field 'user.email', after: '&mdash;'.html_safe
          c.text_field 'user.full_name'
          c.text_field 'user.mobile'
        end
        t.timestamps
      end
    end
  end

  def new_customer_account_form(account, opts = {})
    forma_for @account, title: opts[:title], collapsible: true, icon: opts[:icon] do |f|
      f.text_field :rs_tin, required: true, autofocus: true
      f.text_field :address_code, required: true
      f.text_field :address, required: true, width: 300 #, :voltage, :power, :use, :rs_tin, :count
      f.select_field :customer, select_customer_url, label: 'ბილინგის აბონენტი', search_width: 900
      f.submit opts[:submit]
      f.bottom_action opts[:cancel_url], label: 'გაუქმება', icon: '/icons/cross.png'
    end
  end

  def sms_message_form(message, opts = {})
    forma_for message, title: opts[:title], icon: opts[:icon], collapsible: true do |f|
      f.text_field 'message', required: true, autofocus: true, width: 400
      f.submit opts[:submit]
      f.bottom_action opts[:cancel_url], label: 'გაუქმება', icon: '/icons/cross.png'
    end
  end
end
