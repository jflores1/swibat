# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->
  $('div#activity-form').hide()
  $('.add-new-activity').click (e)->
    $('div#activity-form').fadeIn()
  $('.remove-new-activity').click (e)->
    $('div#activity-form').hide()

  # Standards form
  $( ".corestandards-accordion" ).accordion({
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
      element = $( "<li data-id='" + ui.draggable.data('id') + "' data-content='" + ui.draggable.data('content') + "' title='" + ui.draggable.data('original-title') + "'></li>" ).html( ui.draggable.html() + recycle_icon ).appendTo( $(this).find('ul') )
      updateStandardsFormField()
      # bind the click event on the remove icon    
      $('i.icon-remove').click (event)->
        removeStandard($(this).parent())
      $(element).popover({      
        placement: 'top',
        trigger: 'hover'
      })  
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
    standardsField = $('#standardsField')

    $('#standardsField')[0].value = ids.toString() if $('#standardsField').size() > 0

  $('#saveStandardsForm')    
    .bind("ajax:success", (evt, data, status, xhr)->      
      $('#successModal').modal('show');
    )

  updateStandardsFormField()

  # bind the click event on the remove icons
  $('i.icon-remove').click (event)->
    removeStandard($(this).parent())

  # bind the popover event to standards
  $('.standards-list > li').each (i, element)=>
    $(element).popover({      
      placement: 'top',
      trigger: 'hover'
    })  

  $('.standards > ul > li').each (i, element)=>
    $(element).popover({      
      placement: 'top',
      trigger: 'hover'
    })  

 



