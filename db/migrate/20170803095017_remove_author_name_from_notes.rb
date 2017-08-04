class RemoveAuthorNameFromNotes < ActiveRecord::Migration
  def change
    remove_column :notes, :author_name, :string
  end
end
