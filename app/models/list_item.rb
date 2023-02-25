class ListItem < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 50 }

  def process_created_at
    self.created_at.strftime("%Y-%m-%d %H:%M:%S") 
  end
end
