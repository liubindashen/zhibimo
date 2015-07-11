class AddSloganToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :slogan, :text
  end
end
