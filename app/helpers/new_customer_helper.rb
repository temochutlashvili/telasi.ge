# -*- encoding : utf-8 -*-
module NewCustomerHelper
  def voltage_collection
    { I18n.t('models.network_new_customer_item.voltage_220') => '220',
      I18n.t('models.network_new_customer_item.voltage_380') => '380',
      I18n.t('models.network_new_customer_item.voltage_610') => '6/10'
    }
  end

  def use_collection
    { I18n.t('models.network_new_customer_item.use_personal') => Network::NewCustomerItem::USE_PERSONAL,
      I18n.t('models.network_new_customer_item.use_not_personal') => Network::NewCustomerItem::USE_NOT_PERSONAL,
      I18n.t('models.network_new_customer_item.use_shared') => Network::NewCustomerItem::USE_SHARED
    }
  end
end
