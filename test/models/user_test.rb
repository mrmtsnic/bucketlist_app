require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "test", email: "test@test.com",
                     password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "name shoud not be too long" do
    @user.name = "a" * 11
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 247 + "@test.com"
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
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
    upper_case_email = "TEST@TEST.COM"
    @user.email = upper_case_email
    @user.save
    assert_equal upper_case_email.downcase, @user.reload.email 
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = ""
    assert_not @user.valid?
  end

  test "password containing only blank should be invalid" do
    @user.password = @user.password_confirmation = "         "
    assert_not @user.valid?
  end

  test "password should be too short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "password_confirmation should be same as password" do
    @user.password = "password"
    @user.password_confirmation = "invalid"
    assert_not @user.valid?
  end
end
