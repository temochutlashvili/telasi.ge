# -*- encoding : utf-8 -*-
module ApplicationsHelper
  include Forma::Html

  def applications_list(apps)
    el('div', attrs: { class: 'applications' }, children: apps.map { |app|
      url = "/#{app.split('.').join('/')}"
      el('div', attrs: { class: 'application' }, children: [
        el('div', attrs: { class: 'application-inner' }, children: [
          el('a', attrs: { href: url }, children: [
            el('img', attrs: { src: "/images/#{app.split('.').join('_')}.png" }),
          ]),
          el('div', attrs: { class: 'title' }, children: [
            el('a', attrs: { href: url }, text: t("applications.#{app}_title"))
          ]),
          el('div', attrs: { class: 'description' }, text: t("applications.#{app}_description"))
        ])
      ])
    }).to_s
  end
end
