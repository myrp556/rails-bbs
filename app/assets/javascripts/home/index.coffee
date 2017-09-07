$(document).on 'turbolinks:load', ->

  $('.zone-block').click ->
    window.location.replace $(this).find('a').attr('href')

  $('.hot-topic-td').click ->
    window.location.replace $(this).find('a').attr('href')
  '''
  if $('.home-big-screen-subtitle-text').length>0
    text = $('.home-big-screen-subtitle-text')
    screen = $('.home-big-screen')
    console.log text.height()
    console.log screen.height()
    text.css('top', (screen.height()-text.height())/2)
  '''
