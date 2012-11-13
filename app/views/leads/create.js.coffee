$ ->
    $("#new_lead_modal").modal('show')
    $("#sidebar-quote-form").find('input:text').val('')
    $("#sidebar-quote-form").find("input:radio").removeAttr('selected')