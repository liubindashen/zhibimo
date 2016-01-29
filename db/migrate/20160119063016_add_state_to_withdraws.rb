class AddStateToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :state, :string
  end
end
