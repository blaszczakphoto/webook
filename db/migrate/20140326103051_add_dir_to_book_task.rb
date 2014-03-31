class AddDirToBookTask < ActiveRecord::Migration
  def change
    add_column :book_tasks, :dir, :string
    add_column :book_tasks, :file, :string
    add_column :book_tasks, :downloaded, :boolean
  end
end
