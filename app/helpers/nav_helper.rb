# -*- encoding : utf-8 -*-
module NavHelper
  def nav_menu
    if @nav and @nav.size > 1
      el('ul', attrs: { class: 'breadcrumb' }, children: @nav.each_with_index.map { |(lbl,url), i|
        if i == @nav.size - 1
          el('li', attrs: { class: 'active' }, text: lbl)
        else
          el('li', children: [
            el('a', attrs: { href: url}, text: lbl),
            el('span', attrs: { class: 'divider' }, text: '&raquo;'.html_safe)
          ])
        end
      }).to_s
    end
  end
end
