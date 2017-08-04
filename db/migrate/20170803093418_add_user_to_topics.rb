class AddUserToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :user, :reference
  end
end
