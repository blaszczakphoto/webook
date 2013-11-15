class AddColumnToSimilarSubpages < ActiveRecord::Migration
  def change
    add_column :similar_subpages, :similar_subpage_id, :integer
    remove_column :similar_subpages, :similar_page_id
  end
end
