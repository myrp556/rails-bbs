reply_to = 0
parse_to = 0
reply_name = 0

$(document).on 'turbolinks:load', ->
  $('.topic-options').each ->
    $(this).hide()

  $('.topic-table-tr').each ->
    $(this).hover(
      ->
        $(this).find('.topic-options').show()
      , ->
        $(this).find('.topic-options').hide()
    )

  $('.note-reply-button').each ->
    $(this).click ->
      reply_to = $(this).attr('id')
      parse_to = $(this).attr('parse-to')
      #name = $(this).parent().parent().parent().find('.user-name > strong').html()
      reply_name = $(this).attr('name')
      console.log 'parse-to: ' + parse_to + ' name: ' + reply_name

      $('.modal-reply-title').html $('.modal-reply-title').attr('reply')+': '+reply_name


  $('.note-reply-submit').click ->
    note_reply_detail = $('.note-reply-detail').val()
    console.log note_reply_detail

    $.post '/reply_to_note.json?id='+reply_to, {'parse_to': parse_to, 'note_reply_detail': note_reply_detail}, (respond, status) ->
      if status == 'success'
        if respond.message == 'success'
          #console.log 'redirect '+respond.redirect
          window.location = respond.redirect
        else
          alert 'error'
      else
        alert 'error'
