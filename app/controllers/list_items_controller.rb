class ListItemsController < ApplicationController
  before_action :redirect_login_unless_logged_in,
                only: [:create, :destroy, :update]

  def create
    @list_item = current_user.list_items.build(list_items_params)
    if @list_item.save
      flash[:success] = "やりたいことを追加しました"
      redirect_to current_user
    else
      @user = current_user
      @list_items = @user.list_items.page(params[:page])
      render 'users/show', status: :unprocessable_entity
    end
  end

  def destroy

  end

  def update

  end

  private

    def list_items_params
      params.require(:list_item).permit(:content)
    end
end
