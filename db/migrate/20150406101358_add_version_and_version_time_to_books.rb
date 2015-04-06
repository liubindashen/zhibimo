class AddVersionAndVersionTimeToBooks < ActiveRecord::Migration
  def change
    change_table :books do |t|
      t.string :version
      t.datetime :version_time
    end
  end
end
