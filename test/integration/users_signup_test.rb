require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  
end

class UsersSignupTest < UsersSignup

  test "signup with invalid information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "invalid",
                                         password: "pass",
                                         password_confirmation: "word" } }
    end
    assert_response :unprocessable_entity #レスポンスのステータスコードが
                                          #unprocessable_entityであること
    assert_template 'users/new'
  end

  test "signup with valid information and account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "valid",
                                         email: "valid@valid.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup

  def setup
    super
    post users_path, params: { user: { name: "Activation",
                                       email: "activation@test.com",
                                       password: "password",
                                       password: "password" } }
    @user = assigns(:user)
  end

  test "should not be activatred" do
    assert_not @user.activated?
  end

  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not logged_in?
    assert_not @user.activated?
  end

  test "should not be able to log in with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: 'invalid')
    assert_not logged_in?
    assert_not @user.activated?
  end

  test "should log in successfully with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
  end
end
