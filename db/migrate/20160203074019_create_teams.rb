class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :book_id
      t.integer :author_id
      t.string :access_level

      t.timestamps null: false
    end
  end
end
