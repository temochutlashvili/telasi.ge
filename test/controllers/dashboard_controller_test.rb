# -*- encoding : utf-8 -*-
class DashboardControllerTest < ActionController::TestCase
  test "register user" do
    make_clear_state
    # visit register page
    get :register
    assert_response :success
    refute_nil assigns(:user)
    # register first user
    post :register, sys_user: { email: 'dimakura@gmail.com', password: 'secret', password_confirmation: 'secret', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '599422451' }
    user = assigns(:user)
    refute_nil user
    assert user.errors.empty?
    assert user.email_confirmed
    # register second user
    post :register, sys_user: { email: 'dimitri@invoice.ge', password: 'secret', password_confirmation: 'secret', first_name: 'Dimitri', last_name: 'Kurashvili', mobile: '595335514' }
    user = assigns(:user)
    refute_nil user
    assert user.errors.empty?
    refute user.email_confirmed
    assert_equal 1, ActionMailer::Base.deliveries.size
    # puts ActionMailer::Base.deliveries[0].body
  end
end
