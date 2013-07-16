# -*- encoding : utf-8 -*-
class DashboardControllerTest < ActionController::TestCase
  test "register user" do
    get :register
    assert_response :success
    # assert_equal Acc::Account.by_org(org).where(level: 1).count, assigns(:sub_accounts).count
    # assert_nil assigns(:account)
  end
end
