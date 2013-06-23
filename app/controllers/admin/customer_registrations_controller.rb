class Admin::CustomerRegistrationsController < Admin::AdminController
  def index
    @title = I18n.t('models.billing_customer_registration.admin')
    @registrations = Billing::CustomerRegistration.desc(:_id).paginate(per_page: 15)
  end

  protected

  def nav
    super
    @nav[I18n.t('models.billing_customer_registration.admin')] = admin_customer_registrations_url
  end
end