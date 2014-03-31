class ChangeColumnTaskBookTask < ActiveRecord::Migration
  def up
  	rename_column :book_tasks, :task, :name
  end

  def down
  end
end
