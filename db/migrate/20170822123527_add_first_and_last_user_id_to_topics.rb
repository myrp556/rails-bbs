class AddFirstAndLastUserIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :first_user_id, :integer
    add_column :topics, :last_user_id, :integer
  end
end
