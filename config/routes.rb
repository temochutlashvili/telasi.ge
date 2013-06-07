# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
  namespace 'site' do
    get '/', to: redirect('/site/home')
    scope '/home', controller: 'home' do
      get '/', action: 'index',  as: 'home'
    end
    scope '/about', controller: 'about' do
      get '/', action: 'index',  as: 'about'
    end
    scope '/investors', controller: 'investors' do
      get '/', action: 'index',  as: 'investors'
    end
    scope '/customers', controller: 'customers' do
      get '/', action: 'index',  as: 'customers'
    end
    scope '/tenders', controller: 'tenders' do
      get '/', action: 'index',  as: 'tenders'
    end
    scope '/contact', controller: 'contact' do
      get '/', action: 'index',  as: 'contact'
    end
  end

  root to: redirect('/site/home')
end
