class ChangeBooksReadmeAndSummaryToText < ActiveRecord::Migration
  def change
    change_column :books, :readme, :text
    change_column :books, :summary, :text
  end
end
