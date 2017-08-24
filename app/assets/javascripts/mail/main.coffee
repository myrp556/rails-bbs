$(document).on 'turbolinks:load', ->

  $('.pmail-tr').each ->
    $(this).click ->
      name = $(this).find('.name').html()
      $.get '/get_user_mail.json?pmail_id='+$(this).attr('id'), (respond, status) ->
        if status == 'success'
          if respond.mail_detail?
            $('.pmail-detail').html respond.mail_detail
            $('.modal-title.pmail-name').html name
          else
            $('.pmail-detail').html respond.message
        else
          $('.pmail-detail').html 'error'

  $('.read-pmail-reply').click ->
    $('.new-mail').click()
    $('.mail-receiver').val $('.modal-title.pmail-name').html()
