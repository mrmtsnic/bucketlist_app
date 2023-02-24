class ApplicationController < ActionController::Base
  include SessionsHelper

  # loginが必要な処理の前に必要
  def redirect_login_unless_logged_in
    unless logged_in?
      flash[:danger] = "ログインしてください"
      redirect_to login_url, status: :see_other
    end
  end
end
