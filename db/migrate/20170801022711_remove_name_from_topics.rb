class RemoveNameFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :name, :string
  end
end
