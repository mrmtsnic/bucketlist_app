require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @test_user = users(:test)
    @test_user2 = users(:test2)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@test_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@test_user), params: { user: { name: "foo",
                                              email: "bar"} }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@test_user2)
    get edit_user_path(@test_user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@test_user2)
    patch user_path(@test_user), params: { user: { name: "foo",
                                      email: "bar" } }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@test_user2)
    assert_not @test_user2.admin?
    patch user_path(@test_user2), params: { user: { admin: true } }
    assert_not @test_user2.admin?
  end

  test "should redirect destroy when no logged in" do
    assert_no_difference "User.count" do
      delete user_path(@test_user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should non-admin be redirected to home when delete" do
    log_in_as(@test_user2)
    assert_no_difference "User.count" do
      delete user_path(@test_user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
