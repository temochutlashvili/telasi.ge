# -*- encoding : utf-8 -*-
TelasiGe::Application.routes.draw do
  namespace 'site' do
    get '/', to: redirect('/site/home')
    scope '/home', controller: 'home' do
      get '/', action: 'index',  as: 'home'
    end
    scope '/about', controller: 'about' do
      get '/', to: redirect('/site/about/mission')
      get '/mission', action: 'mission',  as: 'about_mission'
      get '/history', action: 'history',  as: 'about_history'
      get '/law', action: 'law',  as: 'about_law'
      get '/structure', action: 'structure',  as: 'about_structure'
      get '/internals', action: 'internals', as: 'about_internals'
      get '/management', action: 'management', as: 'about_management'
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
