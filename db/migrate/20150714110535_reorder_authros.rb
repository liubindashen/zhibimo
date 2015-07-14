class ReorderAuthros < ActiveRecord::Migration
  def up
    change_column :authors, :gitlab_name, :string, after: :gitlab_id
    change_column :authors, :gitlab_password, :string, after: :gitlab_name
  end

  def down
    raise 'ONLY UP'
  end
end
