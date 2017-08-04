class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :detail
      t.references :zone, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :topics, :updated_at
  end
end
