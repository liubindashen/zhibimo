class RenameGitlabNameToGitlabUsername < ActiveRecord::Migration
  def change
    rename_column :authors, :gitlab_name, :gitlab_username
  end
end
