$(document).on 'turbolinks:load', ->

  $('.zone-block').click ->
    window.location.replace $(this).find('a').attr('href')

  $('.hot-topic-td').click ->
    window.location.replace $(this).find('a').attr('href')

  $.post '/save_page', {'data': {'html': '2333'}}, (respond, status) ->
    console.log status
    console.log respond
    console.log 'save page: ' + respond.message + ' ' + respond.num
