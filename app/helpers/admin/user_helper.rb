# -*- encoding : utf-8 -*-
module Admin::UserHelper
  def user_search(search, opts = {})
    search_form(search, opts) do |f|
      f.text_field 'email', label: t('models.sys_user.email')
      f.text_field 'first_name', label: t('models.sys_user.first_name')
      f.text_field 'last_name', label: t('models.sys_user.last_name')
      f.text_field 'mobile', label: t('models.sys_user.mobile')
    end
  end
end
