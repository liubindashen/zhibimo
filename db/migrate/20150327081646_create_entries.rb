class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string     :path, null: false, index: { unique: true }
      t.references :book, null: false, index: true, foreign_key: true
    end
  end
end
