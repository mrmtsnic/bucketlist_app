class UsersController < ApplicationController
  before_action :redirect_login_unless_logged_in,
                only: [:index, :show, :edit, :update, :destroy]
  before_action :redirect_home_unless_current_user,
                only: [:edit, :update]
  before_action :redirect_home_unless_admin_user, only: [:destroy]
  before_action :guest_user_cant_edit_profile, only: [:update]
  def new
    @user = User.new
  end

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @list_item =  @user.list_items.build
    @list_items_accomplished = @user.list_items.where(accomplished: true)
                                    .page(params[:accomplished_page])
    @list_items_not_accomplished = @user.list_items.where(accomplished: false)
                                        .page(params[:not_accomplished_page])
    @list_items_liked = @user.favorites_except_mine.page(params[:liked_page])                      
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウント承認メールを送りました。ご確認ください。"
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.avatar.attach(params[:user][:avatar])
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url, status: :see_other
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :avatar)
    end

    def redirect_home_unless_current_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "権限がありません"
        redirect_to root_url, status: :see_other
      end
    end
    
    def redirect_home_unless_admin_user
      redirect_to root_url, status: :see_other unless current_user.admin?
    end

    def guest?
      guest_email = "guest@example.com"
      current_user.email ==  guest_email
    end

    def guest_user_cant_edit_profile
      if guest?
        flash[:danger] = "ゲストユーザーはプロフィールを編集できません"
        redirect_to root_url
      end
    end
end
