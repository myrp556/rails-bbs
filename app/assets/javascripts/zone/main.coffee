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
