class AddNoteToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :note, index: true, foreign_key: true
  end
end
