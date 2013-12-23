# -*- encoding : utf-8 -*-
module MenuHelper
  def active?(selector)
    cnt, act = selector.split('#')
    if cnt == controller_path
      if act == '*' 
        return true
      else
        act.split(',').each do |single|
          return true if single == action_name
        end
        return false
        # return act == action_name
      end
    else
      return false
    end
  end

  def locale_url(lang)
    url = request.path
    params[:locale] = lang
    url_for({controller: controller_name, action: action_name}.merge(params))
  end
end
