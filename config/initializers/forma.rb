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

## GEO -> KA automatic conversion

module Forma
  module Utils
    def extract_value(val, name)
      def simple_value(model, name)
        if model.respond_to?(name); model.send(name)
        elsif model.respond_to?('[]'); model[name] || model[name.to_sym]
        end
      end
      name.to_s.split('.').each { |n| val = simple_value(val, n) if val }
      if val.present? and val.is_a?(String)
        val.to_ka
      else
        val
      end
    end
  end
end