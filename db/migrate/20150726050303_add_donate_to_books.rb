class AddDonateToBooks < ActiveRecord::Migration
  def change
    add_column :books, :donate, :boolean
  end
end
