class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :base_url
      t.timestamps
    end
  end
end
