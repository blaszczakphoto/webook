class CreateTableSubpagesSimilarSubpages < ActiveRecord::Migration
  def up
  	create_table :subpages_similar_pages do |t|
      t.belongs_to :subpage
      t.belongs_to :similar_page
    end
  end

  def down
  end
end