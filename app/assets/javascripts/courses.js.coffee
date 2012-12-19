# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('div#comment-form').hide()

  showComment = (e)->
    e.preventDefault()
    $('div#comment-form').show()
    $(this).hide()

  $('#show-comment').click showComment
