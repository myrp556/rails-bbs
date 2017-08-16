refresh_user_zone_privileges = () ->
  $.get '/zones.json', (respond, status) ->
    if status == 'success'
      zones = respond
      #console.log $('.zone-manage').attr('id')
      user_id = $('.zone-manage').attr('id')
      $.get '/user_manage_zones.json?id=' + user_id, (respond, status) ->
        #console.log respond

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
  #console.log ids
  user_id = $('.zone-manage').attr('id')

  $.post '/user_manage_zones.json?id='+user_id, {'ids': ids}, (respond, status) ->
    #console.log status
    if status == 'success'
      refresh_user_zone_privileges()
    else
      console.log 'faild..'

refresh_ball = () ->
  $('.ball').each ->
    block = $(this)
    user_id = $('.zone-manage').attr('id')
    zone_id = $(this).attr('id')
    $.get '/get_user_ball.json?user_id='+user_id+'&zone_id='+zone_id, (respond, status) ->
      #console.log respond.message
      console.log respond
      if status == 'success'
        block.html respond.message
        if respond.status != 'normal' and respond.duration_s?
          block.removeClass('label-success')
          block.addClass('label-danger')
          block.parent().find('.ball-duration').html respond.duration_s
        else
          block.removeClass('label-danger')
          block.addClass('label-success')
          block.parent().find('.ball-duration').html ''
      else
        block.html 'error'

set_user_ball = (block) ->
  zone_id = block.find('.zone').attr('id')
  user_id = $('.zone-manage').attr('id')
  day = block.find('#'+zone_id+'.ball-day').val()
  hour = block.find('#'+zone_id+'.ball-hour').val()
  minute = block.find('#'+zone_id+'.ball-minute').val()
  value = '&day='+day+'&hour='+hour+'&minute='+minute
  #console.log value
  $.get '/set_user_ball.json?user_id='+user_id+'&zone_id='+zone_id+value, (respond, status) ->
    #console.log respond.message
    if status == 'success'
      console.log 'set ball success'
      refresh_ball()
    else
      console.log 'set ball failed'

init_button = () ->
  $('.post-zone-manage').click ->
    send_user_zone_privileges()

  #$('.set-ball').click ->
  #  set_user_ball($(this))

init_view = () ->
  $('.ball-manage').css('display', 'none')

  $('.zone-ball').each ->
    $(this).click ->
      $('.modal-body').html $(this).find('.ball-manage').html()
      $('.modal-set').one 'click', ->
        set_user_ball($('.modal-body'))

$(document).ready ->
#$(window).load ->
  console.log 'ready'

  init_button()
  init_view()

  refresh_user_zone_privileges()
  refresh_ball()
