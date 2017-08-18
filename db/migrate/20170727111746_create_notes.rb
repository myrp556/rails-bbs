class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note_detail
      t.integer :floor, default: 0
      t.integer :zone_id, default: 0
      t.references :topic, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_index :notes, :created_at
  end
end
