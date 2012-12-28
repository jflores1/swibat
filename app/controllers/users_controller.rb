class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
	load_and_authorize_resource
  skip_authorize_resource only: [:index, :show]
  before_filter :load_courses

  def index
    @user = User.all
  end

  def show
  	@user = User.find(params[:id])
    @certifications = @user.professional_accomplishments.where(:accomplishment_type => "Certificate")
    @awards = @user.professional_accomplishments.where(:accomplishment_type => "Award")
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

end
