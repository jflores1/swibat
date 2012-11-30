// Adding and removing fields in forms
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".field").fadeOut();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().parent().before(content.replace(regexp, new_id));
}

function retrieveSimilarObjectiveables(objectiveable_type){
	objective_inputs = $('.objectiveName');
	objectives_array = [];
	for (i = 0; i < objective_inputs.length; i++){
		if (objective_inputs[i].value.length > 0){
			objectives_array.push(objective_inputs[i].value);
		}
	}

	if (objectives_array.length > 0){
		$.ajax({
	    type: "GET",
	    url: '/objectives/similar_objectiveables',
	    data: { objectives : JSON.stringify(objectives_array),
	    				type: objectiveable_type
	    			},
	    dataType: 'json',
	    contentType: 'application/json',
	    success: displayObjectiveables    	
		});		
	}	
}

function displayObjectiveables(objectiveables){
	// the html which would be displayed
	result_html = '';
	for (i = 0; i < objectiveables.length; i++){
		var objectiveable = objectiveables[i].objectiveable;
		// generate the link
		var link = '<a href="' + objectiveables[i].url + '">' + objectiveables[i].link_title + '</a><br />';
		result_html += link;
	}

	// display the HTML
	$('#similarObjectiveables').html(result_html);
}


