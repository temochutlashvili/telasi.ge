class Admin::CustomerRegistrationsController < Admin::AdminController
  def index
    @title = I18n.t('models.billing_customer_registration.admin')
    @registrations = Billing::CustomerRegistration.desc(:_id).paginate(per_page: 15)
  end

  def confirm
    registration = Billing::CustomerRegistration.find(params[:id])
    registration.confirmed = true
    registration.save
    redirect_to admin_customer_registrations_url, notice: I18n.t('models.billing_customer_registration.actions.confirm_complete')
  end

  protected

  def nav
    super
    @nav[I18n.t('models.billing_customer_registration.admin')] = admin_customer_registrations_url
  end
end