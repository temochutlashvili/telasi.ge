# -*- encoding : utf-8 -*-
module SideMenuHelper
  include Forma::Html

  def side_menu(items)
    el('ul', attrs: { class: 'side-menu' }, children: items.map { |x|
      el('li', children: [
        el('a', attrs: { href: x[:url], class: (x[:active] ? 'active' : 'common') }, text: x[:label])
      ])
    })
  end
end
