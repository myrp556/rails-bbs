class AddRatePointToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rate_point, :integer, default: Settings.user_max_rate_point
  end
end
