class AddExpireToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :expire, :datetime
  end
end
