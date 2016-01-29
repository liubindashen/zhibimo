class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.integer :author_id
      t.float :amount
      t.float :fee
      t.float :total
      t.float :balance

      t.timestamps null: false
    end
  end
end
