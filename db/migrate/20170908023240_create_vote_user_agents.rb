class CreateVoteUserAgents < ActiveRecord::Migration
  def change
    create_table :vote_user_agents do |t|
      t.references :vote, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
