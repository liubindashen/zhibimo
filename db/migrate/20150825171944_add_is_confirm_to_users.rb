class AddIsConfirmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_confirm, :boolean
  end
end
