class AddRatedToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :rated, :integer, default: 0
  end
end
