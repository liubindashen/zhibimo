class RenameUserIdToPurchaserId < ActiveRecord::Migration
  def change
    rename_column :orders, :user_id, :purchaser_id
    add_column :orders, :author_id, :integer, after: :purchaser_id
  end
end
