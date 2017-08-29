$(document).on 'turbolinks:load', ->
  image_preview = $('.image-upload-preview-block')
  if image_preview?
    parent = image_preview.parent()
    #image_preview.height(image_preview.width())

  $('.image-upload-change-button').click ->
    $('.image-upload-file-field').click()
  $('.image-upload-upload-button').click ->
    $('.image-upload-submit').click()

  $('.image-upload-file-field').change ->
    ((input) ->
      reader = new FileReader()
      reader.onload = (e) ->
        $('.image-upload-preview').attr('src', e.target.result)
      reader.readAsDataURL input.files[0]
    ) (this)
