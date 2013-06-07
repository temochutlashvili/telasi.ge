# -*- encoding : utf-8 -*-
module Site::MenuHelper
  include Forma::Html

  def site_menu
    controller
    el('ul', attrs: { class: 'nav' }, children: [
      m('home', selected: controller_name == 'home'),
      m('about', selected: controller_name == 'about'),
      m('investors', selected: controller_name == 'investors'),
      m('customers', selected: controller_name == 'customers'),
      m('tenders', selected: controller_name == 'tenders'),
      m('contact', selected: controller_name == 'contact')
    ])
  end

  def m(name, h = {}); Menu.new(h.merge(name: name)).to_e end

  class Menu
    include Forma::Html

    def initialize(h)
      @name = h[:name]
      @label = I18n.t("site.pages.#{@name}.title")
      @url = File.join('/site', @name)
      @children = h[:children]
      @selected = h[:selected]
    end

    def to_e
      el('li', attrs: { class: (@selected ? 'active' : 'common') }, children: [
        el('a', attrs: { href: @url }, text: @label)
      ])
    end
  end
end
