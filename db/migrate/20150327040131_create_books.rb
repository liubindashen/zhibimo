class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.boolean    :building
      t.string     :title
      t.string     :cover_url
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
