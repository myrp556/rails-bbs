class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :author_id
      t.string :author_name
      t.text :detail
      t.integer :floor
      t.references :topic, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :notes, :created_at
  end
end
