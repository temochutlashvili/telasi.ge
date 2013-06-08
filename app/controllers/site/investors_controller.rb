# -*- encoding : utf-8 -*-
class Site::InvestorsController < Site::SiteController
  define_actions('investors', [ 'capital', 'essentials', 'registration', 'reports', 'auditoring', 'notifications' ])
end
