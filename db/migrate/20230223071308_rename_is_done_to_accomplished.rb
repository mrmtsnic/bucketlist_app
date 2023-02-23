class RenameIsDoneToAccomplished < ActiveRecord::Migration[7.0]
  def change
    rename_column :list_items, :is_done, :accomplished
  end
end
