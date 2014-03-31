class AddTitleToBookTasks < ActiveRecord::Migration
  def change
    add_column :book_tasks, :title, :string
  end
end
