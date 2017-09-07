$(document).on 'turbolinks:load', ->
  $('.simple-nav-dropdown-menu').each ->
    $(this).attr 'height', $(this).outerHeight()
    $(this).height 0
    $(this).css 'display', 'none'

  $('.simple-nav-dropdown').on 'mouseover', ->
    #$(this).find('.simple-nav-dropdown-menu').css('display', 'block')
    menu = $(this).find('.simple-nav-dropdown-menu')
    menu.css 'display', 'block'
    menu.animate {'height': menu.attr('height')}, 200

  $('.simple-nav-dropdown').on 'mouseleave', ->
    #$(this).find('.simple-nav-dropdown-menu').css('display', 'none')
    menu = $(this).find('.simple-nav-dropdown-menu')
    menu.animate {'height': 0}, 200, ->
      menu.css 'display', 'none'
