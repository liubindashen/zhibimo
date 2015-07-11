class RemoveUserIdFromBooks < ActiveRecord::Migration
  def up
    change_column_default :books, :user_id, nil
  end

  def down
  end
end
