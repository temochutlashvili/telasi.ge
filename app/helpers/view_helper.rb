# -*- encoding : utf-8 -*-
module ViewHelper
  def yes_no(val)
    if val
      '<i class="fa fa-check-circle text-success"></i>'.html_safe
    else
      '<i class="fa fa-times-circle text-danger"></i>'.html_safe
    end
  end
end
