class AddSlugToBooks < ActiveRecord::Migration
  def change
    change_table :books do |t|
      t.string :slug, index: true
    end
  end
end
