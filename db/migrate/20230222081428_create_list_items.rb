class CreateListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :list_items do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.boolean :is_done, default: false

      t.timestamps
    end
    add_index :list_items, [:user_id, :created_at]
  end
end
