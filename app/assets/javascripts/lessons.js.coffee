# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->
  $('div#activity-form').hide()
  $('.add-new-activity').click (e)->
    $('div#activity-form').fadeIn()
  $('.remove-new-activity').click (e)->
    $('div#activity-form').hide()

  $('div#lesson-content-form').hide()
  $('.add-lesson-content').click (e)->
    $('div#lesson-content-form').fadeIn()

  $('div#lesson-skill-form').hide()
  $('.add-lesson-skill').click (e)->
    $('div#lesson-skill-form').fadeIn()

  # Standards form
  $( ".accordion" ).accordion({
    collapsible: true,
    heightStyle: "content",
    active: false
  });

  $(".draggable").draggable({
    cursor: "move",
    revert: "invalid" ,
    helper: ->
      $copy = $(this).clone()
      return $copy
    appendTo: 'body',
    scroll: false
  });

  recycle_icon = "<i title='Remove this standard' class='icon-remove pull-right' />";
  
  $( ".standards" ).droppable({
    drop: ( event, ui )-> 
      #$( this ).find( ".placeholder" ).remove()
      $( "<li data-id='" + ui.draggable.data('id') + "'></li>" ).html( ui.draggable.text() + recycle_icon ).appendTo( $(this).find('ul') )
      updateStandardsFormField()
      # bind the click event on the remove icon    
      $('i.icon-remove').click (event)->
        removeStandard($(this).parent())
  });

  # remove the standard from the standards list
  removeStandard = (standard)->
    standard.fadeOut(->
      standard.remove()
      updateStandardsFormField()
    )    
  
  updateStandardsFormField = ->
    ids = []
    standards = $('.standards > ul > li')    
    standards.each (i, element)=>
      ids.push($(element).data('id'))    
    $('#standardsField')[0].value = ids.toString();

  $('#saveStandardsForm')    
    .bind("ajax:success", (evt, data, status, xhr)->      
      $('#successModal').modal('show');
    )

  updateStandardsFormField()

  # bind the click event on the remove icons
  $('i.icon-remove').click (event)->
    removeStandard($(this).parent())

  



