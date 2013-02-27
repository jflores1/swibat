class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
	load_and_authorize_resource
  skip_authorize_resource only: [:index, :show, :following, :followers, :search]
  before_filter :load_courses, except: [:index, :eval]
  respond_to :html, :js, :json, :xml

  def index
    @users = User.text_search(params[:q])
  end

  def show
  	@user = User.find(params[:id])
    @certifications = @user.professional_accomplishments.where(:accomplishment_type => "Certificate")
    @awards = @user.professional_accomplishments.where(:accomplishment_type => "Award")
    @microposts = @user.microposts
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
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
  end

  def evaluations
    @user = User.find(params[:id])
    @evaluations = @user.teacher_evaluations    
  end

  def eval
    @user = User.find(params[:id])
    @evaluation = @user.teacher_evaluations.build
    @evaluation.eval_type = params[:eval_type] ? params[:eval_type] : 'evaluation'
    @institution = @user.institution
    @evaluation.evaluation_template = @institution.evaluation_template

    @evaluation.evaluation_template.evaluation_domains.each do |domain|
      domain.evaluation_criteria.each do |criterion|
        @evaluation.evaluation_ratings.build(criterion: criterion)
      end
    end

  end

end
