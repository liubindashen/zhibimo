class AddAccountToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :account, :string
  end
end
