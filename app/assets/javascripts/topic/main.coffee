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
