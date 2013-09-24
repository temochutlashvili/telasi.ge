# -*- encoding : utf-8 -*-
module Network::ChangePowerHelper
  def change_power_table(applications)
    table_for applications, title: 'სიმძლავრის ცვლილების განცხადებები', icon: '/icons/user--pencil.png', collapsible: true do |t|
      t.title_action network_add_change_power_url, label: 'ახალი განცხადება', icon: '/icons/plus.png'
      t.paginate param_name: 'page_change', records: 'ჩანაწერი'
    end
  end
end
