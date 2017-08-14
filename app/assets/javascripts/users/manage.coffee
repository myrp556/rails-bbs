refresh_user_zone_privileges = () ->
  $.get '/zones.json', (respond, status) ->
    if status == 'success'
      zones = respond
      console.log $('.zone-manage').attr('id')
      user_id = $('.zone-manage').attr('id')
      $.get '/user_manage_zones.json?id=' + user_id, (respond, status) ->
        console.log respond

        manage_zone_ids = (data.id for data in respond)
        html = "<ul class='nav nav-pills'>"
        for zone in zones
          zone_name = zone.name
          zone_id = zone.id
          cls = 'manage-zone'
          if zone_id in manage_zone_ids
            cls += ' active'
          html += "<li class='"+cls+"' id='"+zone_id+"' >"
          html += "<a>"+zone_name+"</a>"
          html += "</li>"
        html += "</ul>"


        $('.manage-zones').html( html )
        $('.manage-zone').each ->
          $(this).click ->
            zone_id = $(this).attr('id')
            if $(this).hasClass('active')
              $(this).removeClass('active')
            else
              $(this).addClass('active')

send_user_zone_privileges = () ->
  ids = []
  $('.manage-zone.active').each ->
    ids.push $(this).attr('id')
  console.log ids
  user_id = $('.zone-manage').attr('id')

  $.post '/user_manage_zones.json?id='+user_id, {'ids': ids}, (respond, status) ->
    console.log status
    if status == 'success'
      refresh_user_zone_privileges()
    else
      console.log 'faild..'

init_button = () ->
  $('.post-zone-manage').click ->
    send_user_zone_privileges()

$(document).ready ->
#$(window).load ->
  console.log 'ready'

  init_button()

  refresh_user_zone_privileges()


