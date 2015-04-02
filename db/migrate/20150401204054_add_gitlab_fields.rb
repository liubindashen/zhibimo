class AddGitlabFields < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :gitlab_id
      t.string :gitlab_password
    end

    change_table :books do |t|
      t.integer :gitlab_id
    end
  end
end
