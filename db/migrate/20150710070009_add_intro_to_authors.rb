class AddIntroToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :intro, :text
  end
end
