module NoteHelper
  def note_has_reply?(note)
    return false if Note.find_by(parse_to: note.id).nil?
    true
  end
  
  def get_note_replies(note)
    notes = Note.where(parse_to: note.id)
    return [] if notes.nil?
    notes
  end
end
