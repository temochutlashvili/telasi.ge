# -*- encoding : utf-8 -*-
module Billing::CustomerHelper
  def customer_search(search)
    forma_for search, title: t('models.bs.customer.actions.search'), method: 'get', icon: '/icons/fugue/magnifier.png' do |f|
      f.text_field :accnumb, label: t('models.bs.customer.accnumb'), autofocus: true
      f.submit t('models.bs.customer.actions.search')
    end
  end
end
