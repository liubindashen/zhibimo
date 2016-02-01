class AddOtherGitToBooks < ActiveRecord::Migration
  def change
    add_column :books, :other_git, :string
  end
end
