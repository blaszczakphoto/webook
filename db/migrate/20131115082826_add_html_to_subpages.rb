class AddHtmlToSubpages < ActiveRecord::Migration
  def change
    add_column :subpages, :html, :string
  end
end
