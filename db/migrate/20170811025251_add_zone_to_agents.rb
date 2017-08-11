class AddZoneToAgents < ActiveRecord::Migration
  def change
    add_reference :agents, :zone, index: true, foreign_key: true
  end
end
