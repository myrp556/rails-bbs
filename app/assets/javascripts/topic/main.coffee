reply_to = 0
parse_to = 0
reply_name = 0

$(document).on 'turbolinks:load', ->
  $('.user-profile-mail').each ->
    $(this).click ->
      console.log 'click'
      $('.new-mail').click()
      $('.mail-receiver').val $(this).parent().parent().parent().find('.user-name').find('strong').html()

  $('.select-topic-color').each ->
    $(this).click ->
      topic_id = $(this).parent().parent().attr('id')
      color = $(this).attr('id')
      $.get '/set_topic_color?id='+topic_id+'&color='+color, (respond, status) ->
        if status == 'success'
          if respond.message == 'success'
            console.log 'set '+color+' success'
        else
          alert 'error!'

  $('.note-reply-button').each ->
    $(this).click ->
      reply_to = $(this).attr('id')
      parse_to = $(this).attr('parse-to')
      #name = $(this).parent().parent().parent().find('.user-name > strong').html()
      reply_name = $(this).attr('name')
      #console.log 'parse-to: ' + parse_to + ' name: ' + reply_name
      $('.note-reply-detail').val ''
      $('.note-reply-rate').prop 'checked', false
      $('.modal-reply-title').html $('.modal-reply-title').attr('reply')+': '+reply_name


  $('.note-reply-submit').click ->
    note_reply_detail = $('.note-reply-detail').val()
    console.log note_reply_detail

    $.post '/reply_to_note.json?id='+reply_to, {'parse_to': parse_to, 'note_reply_detail': note_reply_detail, 'rate': $('.note-reply-rate').is(':checked') }, (respond, status) ->
      if status == 'success'
        if respond.message == 'success'
          #console.log 'redirect '+respond.redirect
          window.location.replace respond.redirect
          window.location.reload()
        else
          alert respond.message
      else
        alert 'error'

  $('.note-option-delete-self').click ->
    url = $(this).attr('url')
    $('.delete-note-self-submit').attr('url', url)
  $('.note-option-delete-manage').click ->
    url = $(this).attr('url')
    $('.delete-note-addition-message').val('')
    $('.delete-note-manage-submit').attr('url', url)

  $('.delete-note-self-submit').click ->
    url = $(this).attr('url')
    $.get url, (respond, status) ->
      if status == 'success'
        if respond.message == 'success'
          window.location.replace respond.redirect
        else
          alert respond.message
      else
        alert 'error!'
  $('.delete-note-manage-submit').click ->
    url = $(this).attr('url')
    $.get url+'&am='+$('.delete-note-addition-message').val(), (respond, status) ->
      console.log respond
      if status == 'success'
        if respond.message == 'success'
          window.location.replace respond.redirect
        else
          alert respond.message
      else
        alert 'error'
