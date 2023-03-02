class AddToMylistsController < ApplicationController
  before_action :redirect_login_unless_logged_in

  def create
    # 加えたいリスト
    list_item = ListItem.find(params[:id])
    
    new_list = current_user.list_items.create!(content: list_item.content)
    flash[:info] = "自分のリストに加えました"
    redirect_to current_user
  end
end
