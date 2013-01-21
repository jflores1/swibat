module ApplicationHelper
  
  include EncodeHelper
  include ReputationsHelper

	# Adding and removing nested forms
  def link_to_remove_fields(name, f, confirm = false, link_class)
    if confirm
      f.hidden_field(:_destroy) + link_to_function(raw(name), "if (confirm(\"Are you sure? This will delete the object.\")) { remove_fields(this) }", :class=>"#{link_class}")
    else
      f.hidden_field(:_destroy) + link_to_function(raw(name), "remove_fields(this)", :class=>"#{link_class}")
    end
  end
  
  def link_to_add_fields(name, f, association, link_class)

    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(raw(name), raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class=>"#{link_class}")
  end

  #helpers to allow sign up from any controller. //TODO: Decide whether this should just be on static pages controller.
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def present(object, klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def current_user?
    current_user
  end

end
