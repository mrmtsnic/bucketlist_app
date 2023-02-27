class ListItemsController < ApplicationController
  before_action :redirect_login_unless_logged_in,
                only: [:create, :edit, :destroy, :update, :accomplish]
  before_action :correct_user, only: [:edit, :destroy, :update, :accomplish]

  def create
    @list_item = current_user.list_items.build(list_items_params)
    if @list_item.save
      flash[:success] = "やりたいことを追加しました"
      redirect_to current_user
    else
      redirect_to current_user
    end
  end

  def destroy
    @list_item.destroy
    flash[:success] = "リストを削除しました"
    redirect_to @list_item.user, status: :see_other
  end

  def edit
  end

  def update
    if @list_item.update(list_items_params)
      flash[:success] = "リストを編集しました"
      redirect_to @list_item.user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def accomplish
    @list_item.update(accomplished: true)
    flash[:info] = "#{@list_item.content} を達成しました! おめでとうございます!"
    redirect_to @list_item.user
  end

  private

    def list_items_params
      params.require(:list_item).permit(:content)
    end

    def correct_user
      @list_item = current_user.list_items.find_by(id: params[:id])

      if @list_item.nil?
        flash[:danger] = "あなたのリストではありません"
        redirect_to root_url, status: :see_other
      end
    end
end
