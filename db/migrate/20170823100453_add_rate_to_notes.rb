class AddRateToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :rate, :boolean, default: false
  end
end
