require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:test)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "アカウント承認", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.activation_token, mail.html_part.decoded
    assert_match user.name, mail.html_part.decoded
    assert_match CGI.escape(user.email), mail.html_part.decoded
  end

  test "password_reset" do
    user = users(:test)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "パスワード再設定", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token, mail.html_part.decoded
    assert_match CGI.escape(user.email), mail.html_part.decoded
  end

end
