class LikesController < ApplicationController
  before_action :redirect_login_unless_logged_in

  def create
    @list_item = ListItem.find(params[:list_item_id])
    current_user.like(@list_item)
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  def destroy
    @list_item = ListItem.find(params[:list_item_id])
    current_user.unlike(@list_item)
    if request.referrer.nil?
      redirect_to root_url, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end
end
