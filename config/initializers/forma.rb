# -*- encoding : utf-8 -*-
DATE_FORMAT = '%d-%b-%Y %T %Z'

module SystemFields
  def timestamps
    date_field(:created_at, label: I18n.t('models.general.created_at'), hint: I18n.t('models.general.created_at_hint'), required: true, formatter: DATE_FORMAT)
    date_field(:updated_at, label: I18n.t('models.general.updated_at'), hint: I18n.t('models.general.updated_at_hint'), required: true, formatter: DATE_FORMAT)
  end

  def userstamps
    text_field(:creator, label: I18n.t('models.general.created_by'), hint: I18n.t('models.general.created_by_hint') )
    text_field(:updater, label: I18n.t('models.general.updated_by'), hint: I18n.t('models.general.updated_by_hint') )
  end
end

module CommonActions
  def save_button
    submit I18n.t('models.general.actions.save')
  end

  def cancel_button(url, h={})
    h[:confirm] = I18n.t('models.general.actions.cancel_confirm') if h[:confirm] == true
    bottom_action(
      url,
      label: I18n.t('models.general.actions.cancel'),
      icon: '/icons/cross.png',
      confirm: h[:confirm]
    )
  end

  def edit_action(url)
    if respond_to?(:title_action)
      title_action url, icon: '/icons/fugue/pencil.png', label: I18n.t('models.general.actions.edit')
    else
      action url, icon: '/icons/fugue/pencil.png', label: I18n.t('models.general.actions.edit')
    end
  end

  def delete_action(url)
    if respond_to?(:title_action)
      title_action url, method: 'delete', icon: '/icons/fugue/bin.png', label: I18n.t('models.general.actions.delete'), confirm: I18n.t('models.general.actions.confirm')
    else
      action url, method: 'delete', icon: '/icons/fugue/bin.png', label: I18n.t('models.general.actions.delete'), confirm: I18n.t('models.general.actions.confirm')
    end
  end

  def copy_action(url)
    if respond_to?(:title_action)
      title_action url, icon: '/icons/fugue/documents-text.png', label: I18n.t('models.general.actions.copy')
    else
      action url, icon: '/icons/fugue/documents-text.png', label: I18n.t('models.general.actions.copy')
    end
  end

  def plus_action(url)
    if respond_to?(:title_action)
      title_action url, icon: '/icons/fugue/plus.png', label: I18n.t('models.general.actions.plus')
    else
      action url, icon: '/icons/fugue/plus.png', label: I18n.t('models.general.actions.plus')
    end
  end
end

class Forma::Form
  include SystemFields
  include CommonActions
end

class Forma::Tab
  include SystemFields
  include CommonActions
end

class Forma::Column
  include SystemFields
  include CommonActions
end

## GEO -> KA automatic conversion

class Forma::TextField
  def view_element(val)
    el((@tag || 'span'), text: (password ? '******' : val.to_s.to_ka), attrs: { id: self.id })
  end
end
