class CreateVoteOptions < ActiveRecord::Migration
  def change
    create_table :vote_options do |t|
      t.references :vote, index: true, foreign_key: true
      t.integer :count, default: 0
      t.string :description

      t.timestamps null: false
    end
  end
end
