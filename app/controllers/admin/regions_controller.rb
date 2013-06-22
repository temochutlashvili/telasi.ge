# -*- encoding : utf-8 -*-
class Admin::RegionsController < Admin::AdminController
  def index
    @title = I18n.t('models.billing_region_config.regions')
    @regions = Billing::RegionConfig.asc(:name)
  end

  def sync
    Billing::RegionConfig.sync
    redirect_to admin_regions_url, notice: I18n.t('models.billing_region_config.actions.sync_complete')
  end

  protected

  def nav
    super
    @nav[@title] = nil
    @nav
  end
end
