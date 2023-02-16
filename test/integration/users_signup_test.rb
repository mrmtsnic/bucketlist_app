require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

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

  test "signup with valid information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "test",
                                         email: "test@test.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    end
    # この後に別のリクエストをするときはfollow_redirect!をここに入れること
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
