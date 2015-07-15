class RemoveColsFromBooks < ActiveRecord::Migration
  def change
    remove_columns :books, :user_id
    remove_columns :books, :cover_url
  end
end
