reply_to = 0
parse_to = 0
reply_name = 0

$(document).on 'turbolinks:load', ->
  $('.topic-options').each ->
    $(this).hide()

  $('.topic-table-tr').each ->
    $(this).hover(
      ->
        $(this).find('.topic-options').show()
      , ->
        $(this).find('.topic-options').hide()
    )

  $('.topic-option-delete-self').click ->
    $('.delete-topic-self-submit').attr 'url', $(this).attr('url')
  $('.topic-option-delete-manage').click ->
    $('.delete-topic-manage-submit').attr 'url', $(this).attr('url')
    $('.delete-topic-addition-message').val ''

  $('.delete-topic-self-submit').click ->
    url = $(this).attr('url')
    $.get url, (respond, status) ->
      if status == 'success'
        if respond.message == 'success'
          window.location.replace respond.redirect
        else
          alert respond.message
      else
        alert 'error'

  $('.delete-topic-manage-submit').click ->
    url = $(this).attr('url')
    $.get url+'&am='+$('.delete-topic-addition-message').val(), (respond, status) ->
      if status == 'success'
        if respond.message == 'success'
          window.location.replace respond.redirect
        else
          alert respond.message
      else
        alert 'error'
