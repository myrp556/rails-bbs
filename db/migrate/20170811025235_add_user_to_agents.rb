class AddUserToAgents < ActiveRecord::Migration
  def change
    add_reference :agents, :user, index: true, foreign_key: true
  end
end
