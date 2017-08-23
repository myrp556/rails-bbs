$(document).on 'turbolinks:load', ->
  $('.delete-favorite').click ->
    topic_id = $(this).attr('id')
    $.get '/delete_user_favorite?topic_id='+topic_id, (respond, status) ->
      if status == 'success'
        if respond.message == 'success'
          window.location.reload()
        else
          alert respond.message
      else
        alert respond.message

  $('.add-favorite').click ->
    topic_id = $(this).attr('id')
    $.get '/add_user_favorite?topic_id='+topic_id, (respond, status) ->
      if status == 'success'
        if respond.message == 'success'
          window.location.reload()
        else
          alert respond.message
      else
        alert respond.message
