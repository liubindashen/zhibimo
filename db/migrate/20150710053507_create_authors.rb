class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :pen_name
      t.string :gitlab_user
      t.string :gitlab_password
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
