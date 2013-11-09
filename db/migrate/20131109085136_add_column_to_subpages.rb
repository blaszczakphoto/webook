class AddColumnToSubpages < ActiveRecord::Migration
  def change
    add_column :subpages, :valid, :boolean
  end
end
