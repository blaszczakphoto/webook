class ChangeColumnDownloadedBookTask < ActiveRecord::Migration
  def up
  	change_column :book_tasks, :downloaded, :boolean, :default => false 
  end

  def down
  end
end
