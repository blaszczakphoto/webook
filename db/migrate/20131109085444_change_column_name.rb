class ChangeColumnName < ActiveRecord::Migration
  def up
  	add_column :subpages, :valid_page, :boolean
  	remove_column :subpages, :valid
  end

  def down
  end
end
