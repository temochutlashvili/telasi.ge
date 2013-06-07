# -*- encoding : utf-8 -*-
module Site::MenuHelper
  include Forma::Html

  def site_menu
    controller
    el('ul', attrs: { class: 'nav' }, children: [
      m('home', selected: controller_name == 'home'),
      m('about', selected: controller_name == 'about', children: [
        m('mission'), m('history'), m('law'), m('structure')
      ]),
      m('investors', selected: controller_name == 'investors'),
      m('customers', selected: controller_name == 'customers'),
      m('tenders', selected: controller_name == 'tenders'),
      m('contact', selected: controller_name == 'contact')
    ].map { |x| x.to_e })
  end

  def m(name, h = {}); Menu.new(h.merge(name: name)) end

  class Menu
    include Forma::Html

    def initialize(h)
      @name = h[:name]
      @url = File.join('/site', @name)
      @children = h[:children] || []
      @selected = h[:selected] || false
    end

    def to_e
      class_name = @selected ? 'active' : 'common'
      label = I18n.t("site.pages.#{@name}.title")
      if @children.any?
        el('li', attrs: { class: ['dropdown', class_name] }, children: [
          el('a',
            attrs: { href: '#', class: 'dropdown-toggle', 'data-toggle' => 'dropdown' },
            children: [
              el('span', text: label),
              el('b', attrs: { class: 'caret' })
            ]
          ),
          el(
            'ul',
            attrs: { class: 'dropdown-menu' },
            children: @children.map { |x| x.to_e }
          )
        ])
      else
        
        el('li', attrs: { class: [class_name, 'top'] }, children: [
          el('a', attrs: { href: @url }, text: label)
        ])
      end
    end
  end
end
