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
    patch user_path(@test_user), params: { name: "foo",
                                      email: "bar" }
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
