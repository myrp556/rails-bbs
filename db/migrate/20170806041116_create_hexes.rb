class CreateHexes < ActiveRecord::Migration
  def change
    create_table :hexes do |t|
      t.string :url

      t.timestamps null: false
    end
  end
end
