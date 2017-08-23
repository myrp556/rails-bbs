class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :topic_id

      t.timestamps null: false
    end
  end
end
