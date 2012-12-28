class CoursesController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :load_similar_courses, except: [:index, :new, :feed]
  load_and_authorize_resource
  skip_authorize_resource

  def index
    @courses = Course.recent
  end

  def show
    @course = Course.find(params[:id])
    @user = @course.user
  end

  def new
    @course = current_user.courses.new
    @course.objectives.build
  end

  def create
    @grades = Grade.all
    @course = current_user.courses.new(params[:course])
    if @course.save && params[:save_and_return]
      redirect_to course_path(@course)
    elsif @course.save && params[:course_to_unit]
      redirect_to new_course_unit_path(@course)
    else
      flash[:notice] = "Sorry, there was a mistake with the form"
      render :action => 'new'
    end
  end

  def edit
    @course = current_user.courses.find(params[:id])
    @course.objectives.all
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      redirect_to course_path(@course)
    elsif @course.update_attributes(params[course_to_unit: params[:course]])
      redirect_to new_course_unit_path(@course)
    else
      flash[:error] = "Sorry, there was a mistake with the form"
      render 'edit'
    end

  end

  def destroy

  end

  def feed

  end

  def vote
    @course = Course.find(params[:id])
    if params[:type] == 'clear'
      @course.delete_evaluation(:votes, current_user)
    else
      value = params[:type] == "up" ? 1 : -1      
      @course.add_or_update_evaluation(:votes, value, current_user)
    end
    redirect_to :back, notice: "Thank you for voting"   
  end

  def load_similar_courses
    @course = Course.find(params[:id])
    @similar_courses_based_on_name = Objective.find_similar_objectiveables([@course.to_s], "Course", "name").first(5)
    @similar_courses_based_on_name.delete_if {|c| c[:objectiveable].id == @course.id}
    objectives = @course.objectives.collect {|o| o.objective }
    @similar_courses_based_on_objectives = Objective.find_similar_objectiveables(objectives, "Course", "objectives").first(5)
    @similar_courses_based_on_objectives.delete_if {|c| c[:objectiveable].id == @course.id}
  end

end
