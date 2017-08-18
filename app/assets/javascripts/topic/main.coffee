$(document).on 'turbolinks:load', ->
  $('.user-profile-mail').each ->
    $(this).click ->
      console.log 'click'
      $('.new-mail').click()
      $('.mail-receiver').val $(this).parent().parent().parent().find('.user-name').find('strong').html()
