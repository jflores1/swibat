$(document).ready(function(){
  $('#invitations_form')    
    .bind("ajax:success", function(evt, data, status, xhr){      
      $('#ajaxStatus').text('Success');
      $('#ajaxResponse').text('Invitations have been sent successfully.');
      $('#inviteModal').modal('hide');
      $('#invitationsSuccessModal').modal('show');
    })
    .bind("ajax:error", function(evt, xhr, status, error){
      $('#ajaxStatus').text('Error');
      $('#ajaxResponse').text('There has been an error with the request.');
      $('#inviteModal').modal('hide');
      $('#invitationsSuccessModal').modal('show');
    })
});


