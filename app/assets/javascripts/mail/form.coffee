inputTimer = 0

$(document).on 'turbolinks:load', ->

  $('.new-mail').click ->
    $('.mail-receiver').val ''
    $('.mail-detail').val ''

  $('.mail-receiver').change ->
    console.log 'changed'
    $.get '/search_user_name.json?search='+$(this).val(), (respond, status) ->
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
