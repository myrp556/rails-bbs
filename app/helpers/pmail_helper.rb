module PmailHelper
  include NoteHelper
  include TextHelper

  def make_reply_pmail(note, url)
    pmail = make_up_pmail_with_user_id get_user_name_by_note_id(note.reply_to)
    pmail.mail_detail = t(:you_are_replied) +' '+ "<a href='#{url}'>#{t :check}</a>"
    pmail.mail_detail = add_sign(pmail.mail_detail)
    pmail.save
    pmail
  end

  def make_delete_note_pmail(note, message)
    pmail = make_up_pmail_with_user_id note.user_id
    topic_detail = note.topic.topic_detail
    zone_name = note.topic.zone.name
    if !topic_detail.blank? and !zone_name.blank?
      #pmail.mail_detail += t(:your_note) +
      #pmail.mail_detail += t(:your_note_at_zone)+strong(zone_name)+t(:topic)+strong(topic_detail)+t(:has_been_deleted_by_admin)
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
    topic_detail = topic.topic_detail
    zone_name = topic.zone.name
    if !topic_detail.blank? and !zone_name.blank?
      #pmail.mail_detail = ''
      #pmail.mail_detail += your_topic + strong(topic_detail) + at_zone + strong(zone_name)+t(:has_been_deleted_by_admin)
      pmail.mail_detail = t(:delete_topic_format, :zone => strong(zone_name), :topic => strong(topic_detail))
      if !message.blank? and message!='undefined'
        pmail.mail_detail += '<br>'+strong(t(:addtion_message)+':')+'<br>'
        pmail.mail_detail += get_pure_text(message)
      end
      pmail.mail_detail += sign()
      pmail.save
    end
  end

  private
    def make_up_pmail_with_user_id(user_id)
      pmail = Pmail.new
      pmail.sender_id = 0
      pmail.sender_name = Settings.admin_avatar
      pmail.receiver_id = user_id
      user = User.find_by(id: user_id)
      name = nil
      name = user.name if !user.nil?
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
