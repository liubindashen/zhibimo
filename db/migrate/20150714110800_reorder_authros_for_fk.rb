class ReorderAuthrosForFk < ActiveRecord::Migration
  def up
    change_column :authors, :pen_name, :string, after: :user_id
  end

  def down
    raise 'ONLY UP'
  end
end
