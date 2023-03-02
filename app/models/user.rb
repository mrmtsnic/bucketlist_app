class User < ApplicationRecord
  has_many :list_items, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, through: :likes, source: :list_item
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  has_one_attached :avatar
  validates :name, presence: true, length: { maximum: 10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
                    uniqueness: true,
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png ],
                                     message: "有効なフォーマットではありません" },
                     size: { less_than: 5.megabytes,
                             message: "5MBを超える画像はアップロードできません" }

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
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # ユーザーのアバターのurlを返す
  def avatar_url
    if self.avatar.attached?
      self.avatar
    else
      "default.jpg"
    end
  end

  # いいねする
  def like(list_item)
    self.favorites << list_item
  end

  # いいねを取り消す
  def unlike(list_item)
    self.favorites.destroy(list_item)
  end

  def like?(list_item)
    self.favorites.include?(list_item)
  end

  # いいねしたリストを返す(自分のリストは含まない)
  def favorites_except_mine
    self.favorites.where.not(user_id: self.id)
  end

  def activate
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の有効期限はメールを送信してから２時間
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def mylist?(list_item)
    self.list_items.include?(list_item)
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end