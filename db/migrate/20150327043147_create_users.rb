class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, index: { unique: true }, limit: 64
      t.string :avatar_url

      t.timestamps null: false
    end
  end
end
