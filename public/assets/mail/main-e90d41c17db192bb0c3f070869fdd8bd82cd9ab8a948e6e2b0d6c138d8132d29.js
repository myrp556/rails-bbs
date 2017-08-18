(function() {
  $(document).ready(function() {
    console.log('mail#main ready');
    $('.pmail').each(function() {
      return $(this).click(function() {
        var name;
        name = $(this).find('.name').html();
        return $.get('/get_user_mail.json?pmail_id=' + $(this).attr('id'), function(respond, status) {
          if (status === 'success') {
            if (respond.mail_detail != null) {
              $('.mail-detail').html(respond.mail_detail);
              return $('.modal-title.mail-name').html(name);
            } else {
              return $('.mail-detail').html('error');
            }
          } else {
            return $('.mail-detail').html('error');
          }
        });
      });
    });
    return $('.mail-reply').click(function() {
      $('.new-mail').click();
      return $('.mail-receiver').val($('.modal-title.mail-name').html());
    });
  });

}).call(this);
