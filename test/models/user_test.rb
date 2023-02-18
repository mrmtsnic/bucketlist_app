require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:test)
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user.org user@example
                           user@example..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be saved as lowercase" do
    upper_case_email = "F.TEST@TEST.COM"
    @user.email = upper_case_email
    @user.save
    assert_equal upper_case_email.downcase, @user.reload.email 
  end

  test "password containing only blank should be invalid" do
    @user.password = @user.password_confirmation = "         "
    assert_not @user.valid?
  end

  test "password_confirmation should be same as password" do
    @user.password = "password"
    @user.password_confirmation = "invalid"
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end

end
