class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :courses, :content_map]
	load_and_authorize_resource
  skip_authorize_resource only: [:index, :following, :followers, :search, :courses, :content_map]
  before_filter :load_courses, except: [:index, :eval]
  respond_to :html, :js, :json, :xml

  def index
    @school = current_user.institution
    @users = @school.users
    respond_with @users
  end

  def show
  	@user = User.find(params[:id])
    @institution = @user.institution #TODO: Consider factoring this out and passing as local variable in partial.
    @total_eval_count = Institution.total_evaluations(@institution.id)
    @total_video_count = Institution.total_videos(@institution.id)
    respond_with @user.as_json(include: :institution)
  end

  def edit
  	@user = User.find(params[:id])
    @user.professional_accomplishments.build
    @user.professional_educations.build
    @user.specialties.build   
  end

  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.people_followed

    respond_to do |format|      
      format.html { render action: "followers" }
    end
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    
    respond_to do |format|      
      format.html
    end
  end

  def load_courses
    @user = User.find(params[:id])
    @courses = @user.courses.all
    @courses.each do |course|
      @similar_courses_based_on_name = Objective.find_similar_objectiveables([course.to_s], "Course", "name").first(5)
      @similar_courses_based_on_name.delete_if {|c| c[:objectiveable].id == course.id}
      objectives = course.objectives.collect {|o| o.objective }
      @similar_courses_based_on_objectives = Objective.find_similar_objectiveables(objectives, "Course", "objectives").first(5)
      @similar_courses_based_on_objectives.delete_if {|c| c[:objectiveable].id == course.id}
    end
  end

  def followed_courses
    @user = User.find(params[:id])
    @courses = Course.from_users_followed_by(@user)
    if @courses
      respond_with @courses
    else
      flash[:error] = "It doesn't look you're following anyone with courses!"
      redirect_to :back
    end
  end

  def content_map
    @mapped_lessons = EducationalStandard.covered_by_user(@user)
    @unmapped_lessons = @user.lessons.unmapped
  end

  def followed_maps
    @mapped_lessons = EducationalStandard.covered_by_people_followed(@user)
  end

  def videos
    @user = User.find(params[:id])
    @videos = @user.videos
    respond_with @videos.as_json 
  end

  def evaluations
    @user = User.find(params[:id])
    @evaluations = @user.teacher_evaluations.order("created_at desc")

    @data = []
    @evaluations.each do |evaluation|
      @data << {date: evaluation.created_at, score: evaluation.calculate_score, name: evaluation.name, type: evaluation.eval_type}
    end
    @json_data = @data.to_json
  end

  def eval
    @user = User.find(params[:id])
    @evaluation = @user.teacher_evaluations.build
    @evaluation.eval_type = params[:eval_type] ? params[:eval_type] : 'evaluation'
    @institution = @user.institution
    @evaluation.evaluation_template = @institution.evaluation_templates.find(params[:template_id])

    @evaluation.evaluation_template.evaluation_domains.each do |domain|
      domain.evaluation_criteria.each do |criterion|
        @evaluation.evaluation_ratings.build(criterion: criterion)
      end
    end
  end

  def courses
    @courses = @user.courses
  end

end
