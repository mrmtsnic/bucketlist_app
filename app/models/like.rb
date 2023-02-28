class Like < ApplicationRecord
  belongs_to :user
  belongs_to :list_item

  validates :user_id, uniqueness: { scope: :list_item_id }
end
