class AddHotToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :hot, :integer, default: 0
  end
end
