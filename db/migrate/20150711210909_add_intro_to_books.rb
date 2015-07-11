class AddIntroToBooks < ActiveRecord::Migration
  def change
    add_column :books, :intro, :text
  end
end
