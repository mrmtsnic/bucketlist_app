require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:test)
    @list_item = list_items(:test)
  end

  test "should redirect create when not logged in" do
    post list_item_likes_path @list_item
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    delete list_item_like_path @list_item, "id"
    assert_redirected_to login_url
  end
end
