class AddTopicToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :topic, index: true, foreign_key: true
  end
end
