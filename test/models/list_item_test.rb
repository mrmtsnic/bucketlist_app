require "test_helper"

class ListItemTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:test)
    @list_item = @user.list_items.build(content: "test")
  end

  test "user id should be present" do
    @list_item.user_id = nil
    assert_not @list_item.valid?
  end

  test "content should be present" do
    @list_item.content = ""
    assert_not @list_item.valid?
  end

  test "content should be at most 50 characters" do
    @list_item.content = "a" * 51
    assert_not @list_item.valid?
  end

  test "order should be most recent first" do
    assert_equal list_items(:most_recent), ListItem.first
  end
end
