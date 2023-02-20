class UsersController < ApplicationController
  before_action :redirect_home_unless_logged_in, only: [:edit, :update]
  before_action :redirect_home_unless_not_current_user,
                only: [:edit, :update]
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
      reset_session
      log_in @user
      flash[:success] = "新規登録が完了しました！"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :avatar)
    end

    def redirect_home_unless_logged_in
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to login_url, status: :see_other
      end
    end

    def redirect_home_unless_not_current_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "権限がありません"
        redirect_to root_url, status: :see_other
      end
    end
end
