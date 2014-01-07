class RenameTablePageToWebsite < ActiveRecord::Migration
  def up
  	rename_table :pages, :websites
  end

  def down
  	rename_table :websites, :pages
  end
end
