class AddTodayNotesToZones < ActiveRecord::Migration
  def change
    add_column :zones, :today_notes, :integer, default: 0
  end
end
