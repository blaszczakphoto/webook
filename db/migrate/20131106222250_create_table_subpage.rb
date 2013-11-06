class CreateTableSubpage < ActiveRecord::Migration
  def up
    create_table :subpages do |t|
      t.string :title
      t.string :url
      t.datetime :datetime
      t.text :content
      t.references :page
      t.timestamps
    end
  end

  def down
  end
end
