class AddLinksNumToSubpage < ActiveRecord::Migration
  def change
    add_column :subpages, :links_num, :integer
  end
end
