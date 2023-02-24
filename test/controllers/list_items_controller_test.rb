require "test_helper"

class ListItemsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @list_item = list_items(:test)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'ListItem.count' do
      post list_items_path, params: { list_item: { content: "aaaa" } }
    end
    assert_redirected_to login_url
  end

  test "should redirct destroy when not logged in" do
    assert_no_difference 'ListItem.count' do
      delete list_item_path(@list_item)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch list_item_path @list_item, 
                         params: { list_item: { content: "update" } }
    assert_redirected_to login_url
  end

end
