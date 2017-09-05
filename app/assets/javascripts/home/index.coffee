$(document).on 'turbolinks:load', ->

  $('.zone-block').click ->
    window.location.replace $(this).find('a').attr('href')

  $('.hot-topic-td').click ->
    window.location.replace $(this).find('a').attr('href')
