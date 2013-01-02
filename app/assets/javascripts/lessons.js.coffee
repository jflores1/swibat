# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('div#activity-form').hide()
  $('.add-new-activity').click (e)->
    $('div#activity-form').fadeIn()
  $('.remove-new-activity').click (e)->
    $('div#activity-form').hide()


