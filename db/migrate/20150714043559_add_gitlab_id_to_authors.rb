class AddGitlabIdToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :gitlab_id, :string
  end
end
