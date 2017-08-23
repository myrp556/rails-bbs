class AddReplyToUserIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :reply_to_user_id, :integer
  end
end
