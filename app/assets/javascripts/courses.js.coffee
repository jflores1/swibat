# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#comment-form').hide()
  $('#show-comment').click ->
    if $('#comment-form').is(':visible')
      $('#comment-form').hide()
      $(this).text("Add a comment")
    else
      $('#comment-form').show()
      $(this).text("Hide Comment")

  # Trim the calendar in the calendar view, displaying only 3 months
  trimCalendar()
  $('.popover-with-html').popover({ html : true, trigger : 'hover', placement : 'top' })
  
