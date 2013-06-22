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

  def show
    @region = Billing::RegionConfig.find(params[:id])
    @title = I18n.t('models.billing_region_config.properties')
  end

  protected

  def nav
    super
    @nav[I18n.t('models.billing_region_config.regions')] = admin_regions_url
    if @region
      @nav[@region.name] = admin_region_url(id: @region.id)
    else
      @nav[@title] = nil
    end
    @nav
  end
end
