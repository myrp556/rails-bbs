class AddBulletinToZones < ActiveRecord::Migration
  def change
    add_column :zones, :bulletin, :text
  end
end
