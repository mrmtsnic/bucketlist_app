class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :to_downcase
  validates :name, presence: true, length: { maximum: 10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
                    uniqueness: true,
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # 渡された文字列をハッシュ値にして返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにtokenとハッシュ値を設定する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
    self.remember_digest
  end

  # セッションハイジャック防止
  # このremember_digestは永続セッションのためではない
  def session_token
    self.remember_digest || remember
  end

  # トークンとダイジェストが一致したらtrueを返す
  def authenticated?(remember_token)
    return false if self.remember_digest.nil?
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    def to_downcase
      self.email = email.downcase
    end
end