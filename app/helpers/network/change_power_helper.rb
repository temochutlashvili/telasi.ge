# -*- encoding : utf-8 -*-
module Network::ChangePowerHelper
  def change_power_table(applications)
    table_for applications, title: 'სიმძლავრის ცვლილების განცხადებები', icon: '/icons/user--pencil.png', collapsible: true do |t|
      t.title_action network_add_change_power_url, label: 'ახალი განცხადება', icon: '/icons/plus.png'
      t.text_field 'number', i18n: 'number', tag: 'code'
      t.complex_field i18n: 'status_name', required: true do |c|
        c.image_field :status_icon
        c.text_field :status_name
      end
      t.complex_field i18n: 'rs_name' do |c|
        c.text_field :rs_tin, tag: 'code'
        c.text_field :rs_name, url: ->(x) { network_change_power_url(id: x.id) }
      end
      t.number_field :amount, after: 'GEL'
      t.number_field :days, max_digits: 0, after: 'დღე'
      t.paginate param_name: 'page_change', records: 'ჩანაწერი'
    end
  end

  def change_power_form(application, opts = {})
    forma_for application, title: opts[:title], collapsible: true, icon: opts[:icon] do |f|
      f.tab do |t|
        t.text_field  :number, required: true, autofocus: true
        t.text_field  :rs_tin, required: true
        t.boolean_field :rs_vat_payer, required: true
        t.text_field  :mobile, required: true
        t.email_field :email
        t.text_field  :address, required: true, width: 500
        t.text_field  :work_address, required: true, width: 500
        t.text_field  :address_code, required: true
        t.combo_field :bank_code, collection: banks, empty: false, required: true
        t.text_field  :bank_account, required: true, width: 300
        t.combo_field :old_voltage, collection: voltage_collection, empty: false, required: true
        t.number_field :old_power, after: 'kWh', width: 100, required: true
        t.combo_field :voltage, collection: voltage_collection, empty: false, required: true
        t.number_field :power, after: 'kWh', width: 100, required: true
      end
      f.submit (opts[:submit] || opts[:title])
      f.bottom_action opts[:cancel_url], label: 'გაუქმება', icon: '/icons/cross.png'
    end
  end
end
