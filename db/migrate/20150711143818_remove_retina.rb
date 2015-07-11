class RemoveRetina < ActiveRecord::Migration
  def change
    remove_column :users, :retina_dimensions, :text
    remove_column :books, :retina_dimensions, :text
  end
end
