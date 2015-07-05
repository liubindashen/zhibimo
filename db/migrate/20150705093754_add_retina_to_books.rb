class AddRetinaToBooks < ActiveRecord::Migration
  def change
    add_column :books, :retina_dimensions, :text
  end
end
