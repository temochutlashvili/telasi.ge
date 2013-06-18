# -*- encoding : utf-8 -*-
require 'uri'

module SearchHelper
  def search_form(search, opts = {})
    has_search = search.present? && search.values.any? { |x| x.present? and x != 'nil' }
    forma_for search, title: t('models.general.search'), icon: '/fugue/magnifier.png', collapsible: true, collapsed: !has_search, method: 'get', model_name: 'search' do |f|
      yield f if block_given?
      # f.title_action url_for(action: 'table_config'), label: t('models.table_config.title'), icon: '/fugue/gear.png' if opts[:table_config]
      f.submit t('models.general.search')
      f.bottom_action("#{URI(request.url).path}?search=clear", label: t('models.general.search_clear'), icon: '/fugue/magnifier--minus.png') if has_search
    end
  end

  # def table_config(config, opts = {})
  #   per_page_collection = opts[:per_page_collection] || { '5' => 5, '10' => 10, '15' => 15, '25' => 20, '50' => 50, '100' => 100 }
  #   forma_for config, title: t('models.table_config.title'), icon: '/fugue/gear.png', model_name: 'table_config', collapsible: true do |f|
  #     f.combo_field :order, collection: opts[:order_collection], empty: false
  #     f.combo_field :per_page, collection: per_page_collection, empty: false
  #     f.submit t('models.general.actions.save')
  #     f.bottom_action url_for(action: 'index'), label: t('models.general.actions.cancel'), icon: '/fugue/cross.png'
  #   end
  # end
end
