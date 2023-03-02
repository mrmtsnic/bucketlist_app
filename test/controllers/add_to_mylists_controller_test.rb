require "test_helper"

class AddToMylistsControllerTest < ActionDispatch::IntegrationTest

  test "should create redirect when not logged in" do
    post "/add/#{ListItem.first.id}"
    assert_redirected_to login_url
  end
end
