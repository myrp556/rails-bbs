class AddReplyToToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :reply_to, :integer
    add_column :notes, :parse_to, :integer
  end
end
