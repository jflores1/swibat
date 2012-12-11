module ApplicationHelper
  
  include EncodeHelper 

	# Adding and removing nested forms
  def link_to_remove_fields(name, f, confirm = false)
    if confirm
      f.hidden_field(:_destroy) + link_to_function(name, "if (confirm(\"Are you sure? This will delete the object.\")) { remove_fields(this) }", :class=>"btn")
    else
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class=>"btn")
    end
  end
  
  def link_to_add_fields(name, f, association)

    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class=>"btn")
  end

  def current_user?
    @user == current_user
  end

end
