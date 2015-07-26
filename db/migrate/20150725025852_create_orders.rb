class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, id: false, primary_key: 'id' do |t|
      t.string :id, :null => false
      t.integer :book_id
      t.integer :user_id
      t.string :aasm_state
      t.decimal :fee
      t.string :wx_prepay_id
      t.string :wx_code_url

      t.timestamps null: false
    end
  end
end
