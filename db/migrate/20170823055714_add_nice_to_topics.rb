class AddNiceToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :nice, :boolean, default: false
  end
end
