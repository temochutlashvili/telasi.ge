# -*- encoding : utf-8 -*-
  # -*- encoding : utf-8 -*-
module Admin::NetworkHelper
  def new_customer_form(application, opts = {})
    forma_for application, title: opts[:title], collapsible: true, icon: opts[:icon] do |f|
      f.text_field  :rs_tin,       required: true, autofocus: true
      f.text_field  :mobile,       required: true
      f.email_field :email,        required: true
      f.text_field  :address,      required: true, width: 300
      f.text_field  :bank_code,    required: true
      f.text_field  :bank_account, required: true, width: 300
      f.submit (opts[:submit] || opts[:title])
      f.bottom_action opts[:cancel_url], label: 'გაუქმება', icon: '/icons/cross.png'
    end
  end

  def new_customer_view(application, opts = {})
    def selected_tab
      case params[:tab]
      when 'accounts' then 1
      when 'files' then 2
      when 'sys' then 3
      else 0 end
    end
    view_for application, title: opts[:title], collapsible: true, icon: '/icons/user.png', selected_tab: selected_tab do |f|
      f.tab title: 'ძირითადი', icon: '/icons/user.png' do |t|
        t.action admin_edit_new_customer_url(id: application.id), label: 'შეცვლა', icon: '/icons/pencil.png'
        t.text_field :number, required: true, tag: 'code'
        t.text_field :status_name, required: true
        t.complex_field i18n: 'rs_name', required: true do |c|
          c.text_field :rs_tin, tag: 'code'
          c.text_field :rs_name, url: ->(x) { admin_new_customer_url(id: x.id) }
        end
        t.email_field :email, required: true
        t.text_field :mobile, required: true
        t.text_field :address, required: true, hint: 'განმცხადებლის მისამართი'
        t.col2 do |c|
          c.complex_field label: 'საბანკო ანგარიში', required: true do |c|
            c.text_field :bank_code, tag: 'code'
            c.text_field :bank_account
          end
          c.number_field :amount, after: 'GEL'
          c.number_field :days, max_digits: 0, after: 'დღე'
        end
      end
      f.tab title: "აბონენტები &mdash; <strong>#{application.items.count}</strong>".html_safe, icon: '/icons/users.png' do |t|
        t.table_field :items, table: { title: 'აბონენტები', icon: '/icons/users.png' } do |items|
          items.table do |t|
            t.title_action admin_add_new_customer_account_url(id: application.id), label: 'ინდივიდუალური', icon: '/icons/plus.png'
            t.title_action admin_add_new_customer_account_url(id: application.id, type: 'summary'), label: 'ჯამური', icon: '/icons/plus.png'
            t.item_action ->(x) { admin_edit_new_customer_account_url(app_id: application.id, id: x.id) }, icon: '/icons/pencil.png', tooltip: 'შეცვლა'
            t.item_action ->(x) { admin_link_new_customer_account_url(app_id: application.id, id: x.id) }, icon: '/icons/user.png', tooltip: 'ბილინგის აბონენტთან დაკავშირება'
            t.item_action ->(x) { admin_delete_new_customer_account_url(app_id: application.id, id: x.id) }, icon: '/icons/bin.png', method: 'delete', confirm: 'ნამდვილად გინდათ ამ ანგარიშის შეცვლა?', tooltip: 'წაშლა'
            t.text_field :address
            t.complex_field label: 'ძაბვა / სიმძლავრე' do |c|
              c.text_field :voltage, tag: 'code'
              c.text_field :unit, after: '/'
              c.number_field :power, after: 'კვტ'
            end
            t.complex_field label: 'აბონენტი' do |c|
              c.text_field :rs_tin, tag: 'code'
              c.text_field :rs_name, empty: false
            end
            t.complex_field label: 'ჯამ.რაოდ' do |c|
              c.boolean_field :summary?
              c.text_field :count, tag: 'code', after: 'მრიც.'
            end
            t.complex_field label: 'ბილინგის აბონენტი' do |c|
              c.text_field 'customer.accnumb', tag: 'code'
              c.text_field 'customer.custname'
            end
          end
        end
        t.table_field :calculations, table: { title: 'გათვლები', icon: '/icons/calculator.png' } do |calcs|
          calcs.table do |t|
            t.complex_field i18n: 'voltage' do |c|
              c.text_field 'voltage', tag: 'code'
              c.text_field 'unit'
            end
            t.text_field 'power', tag: 'code', after: t('models.network_new_customer_item.unit_kwt')
            t.number_field 'amount', after: 'GEL'
            t.number_field 'days', after: t('models.network_new_customer_item.unit_days')
          end
        end
      end
      f.tab title: "ფაილები &mdash; <strong>#{application.files.count}</strong>".html_safe, icon: '/icons/book-open-text-image.png' do |t|
        t.table_field :files, table: { title: 'ფაილები', icon: '/icons/book-open-text-image.png' } do |files|
          files.table do |t|
            t.text_field 'file.filename', url: ->(x) { x.file.url }, label: 'ფაილი'
          end
        end
      end
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
      f.text_field :address_code, required: true, autofocus: true
      f.text_field :address, required: true, width: 300 #, :voltage, :power, :use, :rs_tin, :count
      f.combo_field :voltage, collection: voltage_collection, empty: false, required: true
      f.number_field :power, after: 'kWh', width: 100, required: true
      if params[:type] == 'summary'
        f.text_field :count, required: true
      else
        f.text_field :rs_tin, required: true
      end
      f.submit opts[:submit]
      f.bottom_action opts[:cancel_url], label: 'გაუქმება', icon: '/icons/cross.png'
    end
  end
end
