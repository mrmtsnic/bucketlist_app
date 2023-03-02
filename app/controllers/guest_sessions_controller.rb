class GuestSessionsController < ApplicationController

  def create
    user = User.find_or_create_by(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
    log_in(user)
    flash[:success] = "ゲストユーザーとしてログインしました"
    redirect_to user
  end
end
