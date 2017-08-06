class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :name
      t.string :mail
      t.string :number
      t.integer :rank
      t.integer :zone_auth
      t.string :icon

      t.timestamps null: false
    end
  end
end
