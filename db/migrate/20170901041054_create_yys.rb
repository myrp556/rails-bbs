class CreateYys < ActiveRecord::Migration
  def change
    create_table :yys do |t|
      t.string :number
      t.string :name

      t.timestamps null: false
    end
  end
end
