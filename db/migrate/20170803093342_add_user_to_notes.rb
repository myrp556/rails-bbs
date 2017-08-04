class AddUserToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :user, :reference
  end
end
