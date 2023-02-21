class UsersController < ApplicationController
  before_action :redirect_login_unless_logged_in,
                only: [:index, :edit, :update, :destroy]
  before_action :redirect_home_unless_current_user,
                only: [:edit, :update]
  before_action :redirect_home_unless_admin_user, only: [:destroy]
  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
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
    @user.avatar.attach(params[:user][:avatar]) #if @user.avatar.blank?
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

    def redirect_login_unless_logged_in
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to login_url, status: :see_other
      end
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
end
