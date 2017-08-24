module NoteHelper
  include TextHelper

  def get_note_by_id_in_list(id)
    Note.where(id: id)
  end

  def get_user_name_by_note_id(note_id)
    note = Note.find_by(id: note_id)
    return nil if note.nil?
    note.user_id
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

  def get_pure_note_detail_short(note)
    return nil if note.nil?
    detail = get_pure_text(note.note_detail)
    return nil if detail.blank?
    #detail
    detail.truncate(Settings.note_detail_short_length)
  end

  def get_pure_note_detail_short_short(note)
    return nil if note.nil?
    detail = get_pure_text(note.note_detail)
    return nil if detail.blank?
    deail.truncate(Settings.note_detail_short_short_length)
  end

  private

end
