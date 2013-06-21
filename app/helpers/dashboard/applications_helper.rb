# -*- encoding : utf-8 -*-
module Dashboard::ApplicationsHelper
  def applications
    {
      service: [ app('customer', 'user/customer'), app('newcustomer', 'user/newcustomer') ],
      admin:  [ app('admin') ],
    }
  end

  def app(name, url = nil)
    Application.new(name: name, url: url)
  end

  class Application
    attr_reader :name, :title, :description, :url

    def initialize(h = {})
      @name = h[:name]
      @title = I18n.t("applications.#{@name}.title")
      @description = I18n.t("applications.#{@name}.description")
      @url = h[:url] || h[:name]
    end
  end
end
