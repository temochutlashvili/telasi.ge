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

class Forma::Form
  include SystemFields
end

class Forma::Tab
  include SystemFields
end

class Forma::Column
  include SystemFields
end
