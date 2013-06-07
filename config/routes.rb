TelasiGe::Application.routes.draw do
  namespace 'site', controller: 'base' do
    get   '/', action: 'index',  as: 'home'
  end

  root to: redirect('/site')
end
