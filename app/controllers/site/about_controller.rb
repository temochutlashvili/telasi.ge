# -*- encoding : utf-8 -*-
class Site::AboutController < Site::SiteController
  define_actions('about', [ 'mission', 'history', 'law', 'structure', 'internals', 'management' ])
end
