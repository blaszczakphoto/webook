class RenamePageIdToWebsiteIdSubpage < ActiveRecord::Migration
  def up
  	rename_column :subpages, :page_id, :website_id
  end

  def down
  end
end
