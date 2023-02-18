require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test)
  end
  
  test "login with valid email invalid information" do
    # ログイン失敗→flash表示→homeに行く→flashが消えることを確認する
    get login_path
    assert_template 'sessions/new'
    log_in_as(@user, password: "invalid")
    # post login_path, params: { session: { email: @user.email,
    #                                       password: "invalid" } }
    assert_template 'sessions/new'
    assert_response :unprocessable_entity
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information and logout" do
    get login_path
    assert_template 'sessions/new'
    log_in_as @user
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # logout
    delete logout_path
    assert_redirected_to root_url
    assert_response :see_other
    assert_not logged_in?
    delete logout_path # 2番目のウィンドウでログアウトをクリックする
    follow_redirect!
    assert_not flash.empty?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "login with remembering" do
    log_in_as @user, remember_me: '1'
    assert_not cookies[:remember_token].blank?
  end

  test "login without remembering" do
    log_in_as @user, remember_me: '1'
    assert_not cookies[:remember_token].blank?

    log_in_as @user, remember_me: '0'
    assert cookies[:remember_token].blank?
  end

end
