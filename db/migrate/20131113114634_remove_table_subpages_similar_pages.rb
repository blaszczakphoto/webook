class RemoveTableSubpagesSimilarPages < ActiveRecord::Migration
  def up
  	drop_table :subpages_similar_pages
  end

  def down
  end
end
