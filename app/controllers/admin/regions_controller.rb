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
    @title = I18n.t('models.billing_region_config.actions.show')
    @region = Billing::RegionConfig.find(params[:id])
  end

  def edit
    @title = I18n.t('models.billing_region_config.actions.edit')
    @region = Billing::RegionConfig.find(params[:id])
    if request.post?
      # TODO:
    end
  end

  protected

  def nav
    super
    @nav[I18n.t('models.billing_region_config.regions')] = admin_regions_url
    @nav[@region.name] = admin_region_url(id: @region.id) if @region
    @nav[@title] = nil unless action_name == 'show'
    @nav
  end
end
