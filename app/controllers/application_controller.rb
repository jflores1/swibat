class ApplicationController < ActionController::Base    
  protect_from_forgery

  helper_method :yt_client
  
  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = "Sorry, you don't have access to this page!"
    flash[:error] = exception.message
    redirect_to user_session_path
  end

  def after_sign_in_path_for(resource)
    if resource.role == 'school_admin'
      if resource.last_sign_in_at == nil
        intro_user_path(resource)
      else
        faculty_institution_path(resource.institution)
      end
    elsif resource.role == 'teacher'
      institution_faculty_path(resource.institution, resource)
    end      
  end

  def yt_client
    @yt_client ||= YouTubeIt::Client.new(:username => YouTubeITConfig.username , :password => YouTubeITConfig.password , :dev_key => YouTubeITConfig.dev_key)
  end


end
