# -*- encoding : utf-8 -*-
module Site::DocsHelper
  include Forma::Html

  def downloads_table(docs)
    el('table', attrs: { class: 'table table-striped table-hover' }, children: [
      el('tbody', children: docs.map { |doc|
        ext = doc[:url][-3..-1]
        el('tr', children: [
          el('td', text: doc[:label].html_safe),
          el('td', attrs: { width: 200 }, children: [
            el('a', attrs: { href: doc[:url], class: 'download' }, children: [
              el('i', attrs: { class: 'icon-download' }),
              el('span', text: " #{ext.upcase} #{t('site.general.format')}")
            ])
          ])
        ])
      })
    ])
  end
end
