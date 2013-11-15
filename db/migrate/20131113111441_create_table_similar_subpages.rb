class CreateTableSimilarSubpages < ActiveRecord::Migration
  def up
  	create_table :similar_subpages do |t|
      t.belongs_to :subpage
      t.belongs_to :similar_page
    end
  end

  def down
  end
end
