require "test_helper"

class AddToMylistTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:test)
    @not_my_list_item = list_items(:test2)
    log_in_as(@user)
  end

  test "add to mylist successfully" do
    get root_path
    assert_template "static_pages/home"

    post "/add/#{@not_my_list_item.id}"
    assert_redirected_to @user
    follow_redirect!

    # 自分のマイページに追加したリストのコンテントがあることを確認
    assert_match @not_my_list_item.content, response.body
  end

end
