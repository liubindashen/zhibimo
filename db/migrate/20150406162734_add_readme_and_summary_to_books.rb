class AddReadmeAndSummaryToBooks < ActiveRecord::Migration
  def change
    change_table :books do |t|
      t.string :readme
      t.string :summary
    end
  end
end
