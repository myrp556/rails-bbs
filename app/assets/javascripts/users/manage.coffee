refresh_user_zone_privileges = () ->
  $.get '/zones.json', (respond, status) ->
    if status == 'success'
      zones = respond
      #console.log $('.zone-manage').attr('id')
      user_id = $('.zone-manage').attr('id')
      $.get '/user_manage_zones.json?id=' + user_id, (respond, status) ->
        #console.log respond
        if status == 'success'
          if respond.message == 'success'
            manage_zone_ids = (data.id for data in respond.data)
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
          else
            alert 'x'+respond.message_t
        else
          alert 'error'

send_user_zone_privileges = () ->
  ids = []
  $('.manage-zone.active').each ->
    ids.push $(this).attr('id')
  #console.log ids
  user_id = $('.zone-manage').attr('id')

  $.post '/user_manage_zones.json?id='+user_id, {'ids': ids}, (respond, status) ->
    #console.log status
    if status == 'success'
      if respond.message == 'success'
        refresh_user_zone_privileges()
      alert respond.message_t
    else
      alert 'error'

refresh_ball = () ->
  $('.zone-ball').each ->
    block = $(this)
    user_id = $(this).attr('user-id')
    zone_id = $(this).attr('id')
    $.get '/get_user_ball.json?user_id='+user_id+'&zone_id='+zone_id, (respond, status) ->
      #console.log respond.message
      #console.log respond
      if status == 'success'
        if respond.message == 'success'
          ball_block = $('#'+respond.zone_id+'.ball.label')
          duration_block = $('#'+respond.zone_id+'.ball-duration')
          if respond.status != 'normal' and respond.duration_s?
            ball_block.removeClass('label-success')
            ball_block.addClass('label-danger')
          else
            ball_block.removeClass('label-danger')
            ball_block.addClass('label-success')
          duration_block.html respond.duration_s
          ball_block.html respond.status_t
      else
        alert 'error!'

set_user_ball = (block, zone_id) ->
  #zone_id = block.find('.zone').attr('id')
  user_id = $('.zone-manage').attr('id')
  day = block.find('.ball-day').val()
  hour = block.find('.ball-hour').val()
  minute = block.find('.ball-minute').val()
  value = 'id: '+user_id+'&day='+day+'&hour='+hour+'&minute='+minute
  for bb in block.find('.ball-minute')
    console.log bb

  console.log value
  $.post '/set_user_ball.json?user_id='+user_id+'&zone_id='+zone_id, {'user_id': user_id, 'zone_id': zone_id, 'day': day, 'hour': hour, 'minute': minute, 'addtion_message': $('.ball-message').val()}, (respond, status) ->
    #console.log respond.message
    if status == 'success'
      if respond.message == 'success'
        refresh_ball()
      alert respond.message_t
    else
      alert 'error!'

init_button = () ->
  $('.post-zone-manage').click ->
    send_user_zone_privileges()

  #$('.set-ball').click ->
  #  set_user_ball($(this))

init_view = () ->
  $('.ball-manage').css('display', 'none')

  $('.zone-ball').each ->
    $(this).click ->
      zone_id = $(this).attr('id')
      $('.ball-time').val 0
      $('.ball-message').val ''
      $('.ball-modal-title').html $('.manage-user-name').html()+$('.manage-insdruction.uat-zone').html()+$(this).attr('name')+$('.manage-insdruction.uball').html()
      #$('.modal-body').html $(this).find('.ball-manage').html()
      $('.modal-set').one 'click', ->
        set_user_ball($('.modal-body'), zone_id)

$(document).on 'turbolinks:load',  ->
#$(window).load ->

  init_button()
  init_view()

  if $('.zone-manage').length
    refresh_user_zone_privileges()
  if $('.ball-manage-table').length
    refresh_ball()
