$(document).on 'turbolinks:load', ->

  $('.pmail').each ->
    $(this).click ->
      name = $(this).find('.name').html()
      $.get '/get_user_mail.json?pmail_id='+$(this).attr('id'), (respond, status) ->
        if status == 'success'
          if respond.mail_detail?
            $('.mail-detail').html respond.mail_detail
            $('.modal-title.mail-name').html name
          else
            $('.mail-detail').html 'error'
        else
          $('.mail-detail').html 'error'

  $('.mail-reply').click ->
    $('.new-mail').click()
    $('.mail-receiver').val $('.modal-title.mail-name').html()
