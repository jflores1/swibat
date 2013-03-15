# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
app = angular.module("swibat", ["ngResource"])

$(document).ready ->  
  $('button.modal-dismiss').click (e) ->
    (e).preventDefault()
    $("#errorModal").fadeOut()

  $('#user-add-course').tooltip({'title':'Add a new course'})
  #tooltips
  $('.box-profile-pic').tooltip()
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
  'placement':'bottom'
  })
  $('.header-edit').tooltip({
  'title':'Edit Course'
  'placement':'top'
  })
  $('.see-standards-list').tooltip()
  $('.add-standard').tooltip({
    'title':'Assign or Edit Standards'
  })
  $('.add-unit-assessment').tooltip({
    'title':'Add an Assessment'
  })
  $('.complete-lesson').tooltip({
    'title':'Mark the Lesson Complete'
  })
  $('.delete-domain').tooltip({
    'title':'Delete Domain'
  })
  $('.course-journal').tooltip()
  $('.upload-observation').tooltip()
  $('.upload-video').tooltip()
  $('.add-evaluation').tooltip()
  $('.add-observation').tooltip()

  #calendar
  $('.datepicker').datepicker({"dateFormat":"yy-mm-dd"})

  #wysihtml5 editor
  $('.wysihtml5').wysihtml5()

  $('.best_in_place').best_in_place()
  $('.best_in_place').bind "ajax:success", ->
    @innerHTML = @innerHTML.replace(/\n/g, "<br/>")
    
  # $('.char-count').charCount()
