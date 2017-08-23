module NoteHelper
  def get_note_by_id(id)
    Note.where(id: id)
  end

  def note_has_reply?(note)
    return false if Note.find_by(parse_to: note.id).nil?
    true
  end

  def note_has_reply_to?(note)
    return false if Note.find_by(id: note.reply_to).nil?
    true
  end

  def get_note_replies(note)
    notes = Note.where(parse_to: note.id)
    return [] if notes.nil?
    notes
  end

  def get_reply_to_detail_short(note)
    note = Note.find_by(id: note.reply_to)
    return nil if note.nil?
    note.note_detail.first
  end

  def get_note_detail_short(note)
    return nil if note.nil?
    detail = note.note_detail.truncate(Settings.note_detail_short_length)
    return nil if detail.nil?
    if detail.start_with?('<p>')
      return detail if detail.end_with?('</p>')
      return detail+'>' if detail.end_with?('</p')
      return detail+'p>' if detail.end_with?('</')
      return detail+'/p>' if detail.end_with?('<')
      return detail+'</p>'
    end
    detail
  end
end
