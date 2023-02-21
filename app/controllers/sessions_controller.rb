class SessionsController < ApplicationController
  def new
  end

  # login処理
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        flash[:success] = "ログインしました"
        redirect_to user
      else
        message = "アカウントが承認されていません。"
        message += "メールを確認してください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスかパスワードが正しくありません'
      render 'new', status: :unprocessable_entity # renderするときはstatus必要
    end
  end

  # logout処理
  def destroy
    if logged_in?
      log_out
      flash[:success] = 'ログアウトしました'
    end
    redirect_to root_url, status: :see_other
  end
end
