(function() {
  var init_button, init_view, refresh_ball, refresh_user_zone_privileges, send_user_zone_privileges, set_user_ball,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  refresh_user_zone_privileges = function() {
    return $.get('/zones.json', function(respond, status) {
      var user_id, zones;
      if (status === 'success') {
        zones = respond;
        user_id = $('.zone-manage').attr('id');
        return $.get('/user_manage_zones.json?id=' + user_id, function(respond, status) {
          var cls, data, html, i, len, manage_zone_ids, zone, zone_id, zone_name;
          manage_zone_ids = (function() {
            var i, len, results;
            results = [];
            for (i = 0, len = respond.length; i < len; i++) {
              data = respond[i];
              results.push(data.id);
            }
            return results;
          })();
          html = "<ul class='nav nav-pills'>";
          for (i = 0, len = zones.length; i < len; i++) {
            zone = zones[i];
            zone_name = zone.name;
            zone_id = zone.id;
            cls = 'manage-zone';
            if (indexOf.call(manage_zone_ids, zone_id) >= 0) {
              cls += ' active';
            }
            html += "<li class='" + cls + "' id='" + zone_id + "' >";
            html += "<a>" + zone_name + "</a>";
            html += "</li>";
          }
          html += "</ul>";
          $('.manage-zones').html(html);
          return $('.manage-zone').each(function() {
            return $(this).click(function() {
              zone_id = $(this).attr('id');
              if ($(this).hasClass('active')) {
                return $(this).removeClass('active');
              } else {
                return $(this).addClass('active');
              }
            });
          });
        });
      }
    });
  };

  send_user_zone_privileges = function() {
    var ids, user_id;
    ids = [];
    $('.manage-zone.active').each(function() {
      return ids.push($(this).attr('id'));
    });
    user_id = $('.zone-manage').attr('id');
    return $.post('/user_manage_zones.json?id=' + user_id, {
      'ids': ids
    }, function(respond, status) {
      if (status === 'success') {
        return refresh_user_zone_privileges();
      } else {
        return console.log('faild..');
      }
    });
  };

  refresh_ball = function() {
    return $('.ball').each(function() {
      var block, user_id, zone_id;
      block = $(this);
      user_id = $('.zone-manage').attr('id');
      zone_id = $(this).attr('id');
      return $.get('/get_user_ball.json?user_id=' + user_id + '&zone_id=' + zone_id, function(respond, status) {
        if (status === 'success') {
          block.html(respond.message);
          if (respond.status !== 'normal' && (respond.duration_s != null)) {
            block.removeClass('label-success');
            block.addClass('label-danger');
            return block.parent().find('.ball-duration').html(respond.duration_s);
          } else {
            block.removeClass('label-danger');
            block.addClass('label-success');
            return block.parent().find('.ball-duration').html('');
          }
        } else {
          return block.html('error');
        }
      });
    });
  };

  set_user_ball = function(block) {
    var day, hour, minute, user_id, value, zone_id;
    zone_id = block.find('.zone').attr('id');
    user_id = $('.zone-manage').attr('id');
    day = block.find('#' + zone_id + '.ball-day').val();
    hour = block.find('#' + zone_id + '.ball-hour').val();
    minute = block.find('#' + zone_id + '.ball-minute').val();
    value = '&day=' + day + '&hour=' + hour + '&minute=' + minute;
    return $.get('/set_user_ball.json?user_id=' + user_id + '&zone_id=' + zone_id + value, function(respond, status) {
      if (status === 'success') {
        console.log('set ball success');
        return refresh_ball();
      } else {
        return console.log('set ball failed');
      }
    });
  };

  init_button = function() {
    return $('.post-zone-manage').click(function() {
      return send_user_zone_privileges();
    });
  };

  init_view = function() {
    $('.ball-manage').css('display', 'none');
    return $('.zone-ball').each(function() {
      return $(this).click(function() {
        $('.modal-title').html($(this).attr('name'));
        $('.modal-body').html($(this).find('.ball-manage').html());
        return $('.modal-set').one('click', function() {
          return set_user_ball($('.modal-body'));
        });
      });
    });
  };

  $(document).ready(function() {
    console.log('ready');
    init_button();
    init_view();
    refresh_user_zone_privileges();
    return refresh_ball();
  });

}).call(this);
