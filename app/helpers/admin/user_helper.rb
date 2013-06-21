# -*- encoding : utf-8 -*-
module Admin::UserHelper
  def user_search(search, opts = {})
    search_form(search, opts) do |f|
      f.tab do |f|
        f.col1 do |f|
          f.text_field 'email', label: t('models.sys_user.email'), autofocus: true
          f.text_field 'mobile', label: t('models.sys_user.mobile')
        end
        f.col2 do |f|
          f.text_field 'first_name', label: t('models.sys_user.first_name')
          f.text_field 'last_name', label: t('models.sys_user.last_name')
        end
      end
    end
  end

  def user_view(user, opts = {})
    view_for user, title: opts[:title], icon: '/icons/fugue/user.png', collapsible: true do |view|
      view.tab title: t('models.general.general_info'), icon: '/icons/fugue/user.png' do |tab|
        tab.col1 do |c|
          c.email_field :email, required: true
          c.text_field :full_name, required: true
          c.text_field :mobile, required: true
        end
        tab.col2 do |c|
          c.boolean_field :admin
          c.boolean_field :active
        end
      end
      view.tab title: t('models.general.system_info'), icon: '/icons/fugue/traffic-cone.png' do |tab|
        tab.timestamps
      end
    end
  end
end
