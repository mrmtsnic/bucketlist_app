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

  test "should redirect destroy for wrong list_item" do
    log_in_as(users(:test))
    list_item = list_items(:test2)
    assert_no_difference 'ListItem.count' do
      delete list_item_path(list_item)
    end
    assert_not flash.empty?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "should redirect edit for wrong list_item" do
    log_in_as(users(:test))
    list_item = list_items(:test2)
    get edit_list_item_path(list_item)
    assert_not flash.empty?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "should redirect update for wrong list_item" do
    log_in_as(users(:test))
    list_item = list_items(:test2)
    patch list_item_path list_item, params: { list_item: { content: "test" } }
    assert_not flash.empty?
    assert_response :see_other
    assert_redirected_to root_url
  end
end
