class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :book_id
      t.string :hash
      t.string :tag
      t.string :name
      t.string :email
      t.text :message
      t.datetime :at

      t.timestamps null: false
    end
  end
end
