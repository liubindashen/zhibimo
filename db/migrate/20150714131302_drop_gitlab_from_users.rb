class DropGitlabFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :gitlab_id
    remove_column :users, :gitlab_password
  end
end
