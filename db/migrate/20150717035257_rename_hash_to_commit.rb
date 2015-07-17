class RenameHashToCommit < ActiveRecord::Migration
  def change
    rename_column :builds, :hash, :commit
  end
end
