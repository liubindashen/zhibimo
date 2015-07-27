class AddProfitToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :profit, :string
  end
end
