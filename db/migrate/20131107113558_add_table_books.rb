class AddTableBooks < ActiveRecord::Migration
  def up
    create_table :books do |t|
      t.text :content
      t.references :page
      t.timestamps
    end
  end

  def down
  end
end
