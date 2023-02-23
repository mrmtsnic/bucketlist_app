require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin_user = users(:test)
    @non_admin_user = users(:test2)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin_user)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    User.page(1).each do |user|
      assert_select 'a[href=?]', user_path(user), text:user.name
      unless user == @admin_user
        assert_select 'a[href=?]', user_path(user), text: '削除'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin_user)
      assert_response :see_other
      assert_redirected_to users_url
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin_user)
    get users_path
    assert_select 'a', text: '削除', count: 0
  end
end
