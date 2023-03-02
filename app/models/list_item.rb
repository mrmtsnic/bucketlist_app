class ListItem < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }

  def process_created_at
    self.created_at.strftime("%Y-%m-%d %H:%M:%S") 
  end

  # 指定した数のリストアイテムをランダムに取ってくる
  def ListItem.take_random(take_num: 2)
    random_nums = self.pluck(:id).shuffle[0..(take_num - 1)]
    @list_items_random = self.find(random_nums)
  end
end
