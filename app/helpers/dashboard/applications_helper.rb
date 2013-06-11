# -*- encoding : utf-8 -*-
module Dashboard::ApplicationsHelper
  def applications
    {
      service: [ app('customer'), app('newcustomer') ],
      admin:  [ app('admin') ],
    }
  end

  def app(name)
    Application.new(name: name)
  end

  class Application
    attr_reader :name, :title, :description

    def initialize(h = {})
      @name = h[:name]
      @title = I18n.t("applications.#{@name}.title")
      @description = I18n.t("applications.#{@name}.description")
    end
  end
end
