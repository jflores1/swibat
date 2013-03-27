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

  def show_institution
    if signed_in? && current_user.institution.present?
      current_user.institution.name.titleize
    elsif signed_in?
      render partial: 'shared/banner_invite'
    else
      render partial: 'shared/banner_sign_up'
    end
  end

  def show_current_user_management
    if signed_in? && current_user.school_admin? && !current_user.institution.nil?
      render 'shared/header_current_user_management'
    end
  end

  def show_current_user_courses
    if signed_in?
      render 'shared/header_current_user_courses'
    else
      content_tag :li do
        concat(link_to "sign up", new_user_registration_path)
      end
    end
  end

  def show_current_user_maps
    if signed_in?
      render 'shared/header_current_user_maps'
    end
    
  end

  def show_current_user_calendar
    if signed_in? && current_user.courses.count > 0
      render 'shared/header_current_user_calendars'
    end
  end

  def show_manage_options
    if signed_in?
      render 'shared/header_current_user_manage_options'
    end
  end

  def my_page
    if current_user == @user
      true
    end
  end

  def no_profile_content
    if !@user.specialties.any? && !@certifications.any? && !@awards.any? && !@user.professional_educations.any?
      true
    end
  end

  def normal_date_format(date)
    date.strftime("%d %B %Y")    
  end

  def show_appropriate_sidebar(user)
    if user.school_admin? || user.admin?
      render partial: 'users/admin_sidebar_menu', locals: {user: user}
    else
      render partial: 'users/teacher_sidebar_menu', locals: {user: user}
    end
  end

  def show_appropriate_dashboard(user)
    if user.school_admin?
      render partial: "users/admin_dashboard", locals: {user: user}
    else
      render partial: "users/teacher_dashboard", locals: {user: user}
    end

  end

end
