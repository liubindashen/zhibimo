class ChangeGitlabUserToGitlabNameAuthors < ActiveRecord::Migration
  def change
    rename_column :authors, :gitlab_user, :gitlab_name
  end
end
