# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('.char-count').charCount()

  $('button.modal-dismiss').click (e) ->
    (e).preventDefault()
    $("#errorModal").fadeOut()

  $('#user-add-course').tooltip({'title':'Add a new course'})
  #tooltips
  $('.edit-user-course').tooltip({
  'title':'Edit this course'
  'placement':'right'})
  $('#course-add-unit').tooltip({
  'title':'Add a new unit'
  'placement':'right'
  })
  $('.edit-course-unit').tooltip({
  'title':'Edit this unit'
  'placement':'right'
  })
  $('#add-lesson').tooltip({'title':'Add a new lesson'})
  $('.edit-unit-lesson').tooltip({
  'title':'Edit this lesson'
  'placement':'right'
  })
  $('.add-new-activity').tooltip({'title':'Add an activity to this lesson'})
  $('.get-syllabus').tooltip({
  'title':'See the full syllabus'
  'placement':'right'
  })
  $('.header-edit').tooltip({
  'title':'Edit Course'
  'placement':'top'
  })

  #calendar
  $('.datepicker').datepicker({"dateFormat":"yy-mm-dd"})

  #wysihtml5 editor
  $('.wysihtml5').wysihtml5()
