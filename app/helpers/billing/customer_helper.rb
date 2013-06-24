# -*- encoding : utf-8 -*-
module Billing::CustomerHelper
  def customer_search(search)
    forma_for search, title: t('models.bs.customer.actions.search'), method: 'get', icon: '/icons/fugue/magnifier.png' do |f|
      f.text_field :accnumb, label: t('models.bs.customer.accnumb'), autofocus: true
      f.submit t('models.bs.customer.actions.search')
    end
  end

  def basic_customer_view(customer)
    view_for customer, title: t('models.bs.customer.actions.show'), icon: '/icons/fugue/light-bulb.png' do |v|
      v.tab title: t('models.general.general_info'), icon: '/icons/fugue/light-bulb.png' do |v|
        v.text_field :accnumb, tag: 'code', required: true
        v.text_field :custname, required: true
        v.number_field :balance, after: 'GEL', required: true
        v.number_field 'trash_customer.curr_balance', after: 'GEL'
        v.number_field 'current_water_balance', after: 'GEL'
      end
      v.tab title: t('models.bs.customer.region'), icon: '/icons/fugue/building.png' do |v|
        v.text_field 'region', required: true
        v.text_field 'region.region_config.address', label: t('models.bs.customer.region_address')
        v.text_field 'region.region_config.phone', label: t('models.bs.customer.region_phone')
        v.map_field  'region.region_config.location', label: t('models.bs.customer.region_location'), height: 400, width: 700
      end
    end
  end
end
