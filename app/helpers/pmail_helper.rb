module PmailHelper
  include NoteHelper
  include TextHelper

  def get_pmail_detail_preview(pmail)
    get_pure_text_one_line(pmail.mail_detail).truncate(Settings.pmail_detail_preview_length)
  end

  def make_reply_pmail(note, url)
    pmail = make_up_pmail_with_user_id get_user_name_by_note_id(note.reply_to)
    pmail.mail_detail = t(:you_are_replied) +' '+ "<a href='#{url}'>#{t :check}</a>"
    pmail.mail_detail += sign()
    pmail.save
    pmail
  end

  def make_admin_pmail_to_user(user, detail)
    pmail = make_up_pmail_with_user_id user.id
    return if pmail.nil?
    pmail.mail_detail = get_pure_text(detail)
    pmail.mail_detail += sign()
    pmail.save()
  end

  def make_delete_note_pmail(note, message)
    pmail = make_up_pmail_with_user_id note.user_id
    return if pmail.nil?
    topic_detail = note.topic.topic_detail
    zone_name = note.topic.zone.name
    if !topic_detail.blank? and !zone_name.blank?
      pmail.mail_detail = t(:delete_note_format, :zone => strong(zone_name), :topic => strong(topic_detail), :note_short => small(get_pure_note_detail_short_short(note)))
      if !message.blank? and message!='undefined'
        pmail.mail_detail += '<br>'+strong(t(:addtion_message)+':') + '<br>'
        pmail.mail_detail += get_pure_text(message)
      end
      pmail.mail_detail += sign()
      pmail.save
    end
  end

  def make_delete_topic_pmail(topic, message)
    pmail = make_up_pmail_with_user_id topic.user_id
    return if pmail.nil?
    topic_detail = topic.topic_detail
    zone_name = topic.zone.name
    if !topic_detail.blank? and !zone_name.blank?
      pmail.mail_detail = t(:delete_topic_format, :zone => strong(zone_name), :topic => strong(topic_detail))
      if !message.blank? and message!='undefined'
        pmail.mail_detail += '<br>'+strong(t(:addtion_message)+':')+'<br>'
        pmail.mail_detail += get_pure_text(message)
      end
      pmail.mail_detail += sign()
      pmail.save
    end
  end

  def make_ball_pmail(user_id, zone_name, time_s, message)
    pmail = make_up_pmail_with_user_id user_id
    return if pmail.nil?
    pmail.mail_detail = t(:zone)+'<strong>'+zone_name+'</strong>'+t(:you_are_balled)+"<br>"
    pmail.mail_detail += t(:ball_time)+'<strong>'+time_s+'</strong>'
    if !message.blank?
      pmail.mail_detail += '<br>'+strong(t(:addtion_message)+':')+'<br>'
      pmail.mail_detail += get_pure_text(message)
    end
    pmail.mail_detail += sign()
    pmail.save
  end

  private
    def make_up_pmail_with_user_id(user_id)
      pmail = Pmail.new
      pmail.sender_id = 0
      pmail.sender_name = Settings.admin_avatar
      pmail.receiver_id = user_id
      user = User.find_by(id: user_id)
      return nil if user.nil?
      name = user.name
      pmail.receiver_name = name
      pmail
    end

    def sign()
      '<br>'+t(:thats_all)+'<br>'+Settings.admin_avatar
    end
    def strong(text)
      '<strong>'+text+'</strong>'
    end
    def small(text)
      '<small>'+text+'</small>'
    end
end
