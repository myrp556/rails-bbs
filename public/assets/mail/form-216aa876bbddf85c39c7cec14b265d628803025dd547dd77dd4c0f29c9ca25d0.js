(function() {
  var inputTimer;

  inputTimer = 0;

  $(document).on('turbolinks:load', function() {
    console.log('mail ready');
    $('.new-mail').click(function() {
      $('.mail-receiver').html('');
      return $('.mail-detail').html('');
    });
    $('.mail-receiver').change(function() {
      console.log('changed');
      return $.get('/search_user_name.json?search=' + $(this).val(), function(respond, status) {
        var html, i, len, name, ref;
        console.log(respond);
        html = '';
        ref = respond.names;
        for (i = 0, len = ref.length; i < len; i++) {
          name = ref[i];
          html += "<div class='receiver-name'>" + name + "</div>";
        }
        $('.receivers').html(html);
        return $('.receiver-name').each(function() {
          return $(this).click(function() {
            $('.mail-receiver').val($(this).html());
            return $('.receivers').html('');
          });
        });
      });
    });
    return $('.mail-send').click(function() {
      return $.post('/new_mail.json', {
        'mail_detail': $('.mail-detail').val(),
        'receiver_name': $('.mail-receiver').val()
      }, function(respond, status) {
        if (status === 'success') {
          return alert(respond.message);
        } else {
          return alert('error!');
        }
      });
    });
  });

}).call(this);
