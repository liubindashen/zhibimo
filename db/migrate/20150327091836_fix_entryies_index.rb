class FixEntryiesIndex < ActiveRecord::Migration
  def change
    remove_index :entries, ["path"]
    add_index :entries, ["book_id", "path"], name: "index_entries_on_book_id_and_path", unique: true
  end
end
