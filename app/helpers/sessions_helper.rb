module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  # ログイン中のユーザーを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ログインしてるか確認する
  def logged_in?
    if current_user
      true
    else
      false
    end
  end

  def log_out
    reset_session
    @current_user = nil
  end
end
