# -*- encoding : utf-8 -*-
module MenuHelper
  include Forma::Html

  def application_menu
    menu([ mi(name: 'home', url: '/', select: 'dashboard#index') ])
  end

  def application_right_menu
    if current_user
      menu([ mi(name: 'profile', select: 'profile#*', label: current_user.full_name) ])
    else
      menu([ mi(name: 'login', select: 'dashboard#login') ])
    end
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
      @label = opts[:label] || I18n.t("menu.#{@name}")
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
      children =[ el('a', attrs: { href: @url }, text: @label) ]
      el('li', attrs: { class: ( current? ? 'current' :  'common') }, children: children)
    end
  end
end
