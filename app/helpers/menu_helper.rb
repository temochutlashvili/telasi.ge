# -*- encoding : utf-8 -*-
module MenuHelper
  include Forma::Html

  def application_menu
    # items = [
    #   mi(name: 'customer', split: 'customer#index')
    # ]
    # el('ul', attrs: { class: 'nav' }, children: items.map { |x| x.to_e }).to_s
    ''
  end

  def application_right_menu
    menu([
      mi(name: 'login')
    ])
  end

  private

  def menu(items); el('ul', attrs: { class: 'nav' }, children: items.map { |x| x.to_e }).to_s end
  def mi(opts = {}); MenuItem.new(opts.merge(controller_name: controller_name, action_name: action_name)) end

  class MenuItem
    include Forma::Html
    def initialize(opts)
      @name = opts[:name]
      @url = opts[:url] || "/#{@name}"
      @select = {}
      @controller_name = opts[:controller_name]
      @action_name = opts[:action_name]
      opts[:select].split(' ').each do |s|
        a = s.split('#')
        @select[a[0]] = a[1].split(',') if a[1]
      end if opts[:select]
    end

    def current?
      cntrl = @select[@controller_name]
      cntrl and (cntrl.include?(@action_name) or cntrl.include?('*'))
    end

    def to_e
      el('li', attrs: { class: ( current? ? 'current' :  'common') }, children: [
        el('a', attrs: { href: @url }, text: I18n.t("menu.#{@name}"))
      ])
    end
  end
end
