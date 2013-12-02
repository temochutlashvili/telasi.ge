# -*- encoding : utf-8 -*-
module MenuHelper
  def active?(selector)
    cnt, act = selector.split('#')
    if cnt == controller_name
      if act == '*' then true
      else act == action_name
      end
    else false
    end
  end
end
