require "test_helper"

class ListItemsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:test)
    log_in_as @user
  end

  test "create list-item successfully" do
    content = "test"
    assert_difference 'ListItem.count', 1 do
      post list_items_path, params: { list_item: { content: content } }
    end
    assert_redirected_to @user
    follow_redirect!
    assert_match content, response.body
  end

  test "delete list-item successfully" do
    list_item = @user.list_items.first
    assert_difference 'ListItem.count', -1 do
      delete list_item_path(list_item)
    end
  end

  test "edit list-item content successfully" do
    list_item = @user.list_items.first
    content = "test"
    patch list_item_path list_item,
          params: { list_item: { content: content } }
    assert_equal content, list_item.reload.content
  end
end
