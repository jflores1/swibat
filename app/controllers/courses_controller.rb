class CoursesController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index, :syllabus]
  before_filter :load_similar_courses, except: [:index, :new, :create, :feed, :vote, :fork]
  before_filter :new_micropost, only: [:show]
  load_and_authorize_resource
  skip_authorize_resource only: [:show, :index, :syllabus]
  respond_to :html, :json

  def index
    if params[:tag]
      @courses = Course.tagged_with(params[:tag]).recent
    else
      @courses = Course.recent
    end
  end

  def show
    @course = Course.find(params[:id])
    @user = @course.user
    @microposts = @user.feed
  end

  def new
    @course = Course.new
    @course.objectives.build
  end

  def create
    @grades = Grade.all
    @course = current_user.courses.build(params[:course])
    if @course.save && params[:save_and_return]
      redirect_to course_path(@course)
    elsif @course.save && params[:course_to_unit]
      redirect_to new_course_unit_path(@course)
    else
      flash[:error] = "Sorry, there was a mistake with the form"
      render :action => 'new'
    end
  end

  def edit
    @course = Course.find(params[:id])
    @course.objectives.all
  end

  def update
    @course = Course.find(params[:id])
    @course.update_attributes(params[:course])
    respond_with @course
  end

  def destroy

  end

  def feed
    @courses = current_user.friend_courses.feed_sort

  end

  def syllabus
    @user = @course.user
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "syllabus",
               :template => "courses/syllabus.pdf.erb",
               :margin => {
                  :top => "15",
                  :right => "15",
                  :bottom => "15",
                  :left => "15"
                },
               :footer => {
                  :html => {
                    :template => 'courses/syllabus_footer.pdf.erb'
                  },
                  :left => "Create your own course for free! Visit http://www.swibat.com"
               }
      end
    end
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

  def fork
    @course = Course.find(params[:id])
    @new_course = @course.duplicate_for current_user
    if @new_course != nil      
      redirect_to course_path(@new_course), notice: "Successfully copied the course"
    else
      redirect_to :back, notice: "There has been an error while trying to copy the course"
    end
  end


  def load_similar_courses
    @course = Course.find(params[:id])
    @similar_courses_based_on_name = Objective.find_similar_objectiveables([@course.to_s], "Course", "name").first(5)
    @similar_courses_based_on_name.delete_if {|c| c[:objectiveable].id == @course.id}
    objectives = @course.objectives.collect {|o| o.objective }
    @similar_courses_based_on_objectives = Objective.find_similar_objectiveables(objectives, "Course", "objectives").first(5)
    @similar_courses_based_on_objectives.delete_if {|c| c[:objectiveable].id == @course.id}
  end

  def new_course_goal
    @course = Course.find(params[:id])
    @objective = @course.objectives.build
  end

  def course_goal
    @objective = @course.objectives.build(params[:objective])
    @objective.save!
  end

  def new_micropost 
    @micropost = current_user.microposts.build if signed_in?
  end

  def unit_calendar
    @course = Course.find(params[:id])
    @user = @course.user
    @microposts = @user.feed
    @date = Date.today
    @units_by_date = @course.units.all.group_by(&:expected_start_date)
  end
  
  def journal
    @course = Course.find(params[:id])
  end

end
