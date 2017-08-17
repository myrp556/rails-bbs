inputTimer = 0

$(document).on 'turbolinks:load', ->
  console.log 'mail ready'

  $('.new-mail').click ->
    $('.mail-receiver').html ''
    $('.mail-detail').html ''

  $('.mail-receiver').change ->
    console.log 'changed'
    $.get '/search_user_name.json?search='+$(this).val(), (respond, status) ->
      console.log respond
      html = ''
      for name in respond.names
          html += "<div class='receiver-name'>"+name+"</div>"
      $('.receivers').html html
      $('.receiver-name').each ->
        $(this).click ->
          $('.mail-receiver').val $(this).html()
          $('.receivers').html ''

  $('.mail-send').click ->
    $.post '/new_mail.json', {'mail_detail': $('.mail-detail').val(), 'receiver_name': $('.mail-receiver').val()}, (respond, status) ->
      if status == 'success'
        alert respond.message
      else
        alert 'error!'
