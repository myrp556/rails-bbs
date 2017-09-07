class AddRankToZones < ActiveRecord::Migration
  def change
    add_column :zones, :rank, :integer, default: 0
  end
end
