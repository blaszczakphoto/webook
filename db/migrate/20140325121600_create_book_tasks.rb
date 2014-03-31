class CreateBookTasks < ActiveRecord::Migration
  def change
    create_table :book_tasks do |t|
      t.string :email
      t.string :task
      t.text :links

      t.timestamps
    end
  end
end
