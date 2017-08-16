class CreateBalls < ActiveRecord::Migration
  def change
    create_table :balls do |t|
      t.integer :zone_id
      t.datetime :expire
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
