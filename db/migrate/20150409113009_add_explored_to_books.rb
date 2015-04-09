class AddExploredToBooks < ActiveRecord::Migration
  def change
    add_column :books, :explored, :boolean
  end
end
