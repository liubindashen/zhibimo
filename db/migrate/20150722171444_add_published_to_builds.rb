class AddPublishedToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :published, :boolean
  end
end
