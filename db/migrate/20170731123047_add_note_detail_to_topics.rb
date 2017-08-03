class AddNoteDetailToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :note_detail, :string
  end
end
