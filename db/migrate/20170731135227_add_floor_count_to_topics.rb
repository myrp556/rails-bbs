class AddFloorCountToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :floor_count, :integer, :default => 0
  end
end
