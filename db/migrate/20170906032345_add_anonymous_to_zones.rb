class AddAnonymousToZones < ActiveRecord::Migration
  def change
    add_column :zones, :anonymous, :boolean, default: false
  end
end
