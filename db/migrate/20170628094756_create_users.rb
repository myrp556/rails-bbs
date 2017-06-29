class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :name
      t.string :mail
      t.integer :number
      t.integer :rank
      t.integer :zone_auth

      t.timestamps null: false
    end
  end
end
