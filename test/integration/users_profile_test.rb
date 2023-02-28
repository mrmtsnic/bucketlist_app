require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'ul.list-group'
    assert_match @user.list_items.count.to_s, response.body
    assert_select 'ul.pagination'
    @user.list_items.page(1).each do |list_item|
      assert_match list_item.content, response.body
    end
  end
end
