class CreatePmails < ActiveRecord::Migration
  def change
    create_table :pmails do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :mail_detail
      t.text :sender_name
      t.text :receiver_name
      t.boolean :readed, default: false

      t.timestamps null: false
    end
  end
end
