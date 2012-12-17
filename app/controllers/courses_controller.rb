class CoursesController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource
  skip_authorize_resource

  def index

  end

  def show
    @user = User.find(params[:user_id])
    @course = Course.find(params[:id])    
  end

  def new
    @course = current_user.courses.new
    @course.objectives.build
  end

  def create
    @grades = Grade.all
    @course = current_user.courses.new(params[:course])
    if @course.save && params[:save_and_return]
      redirect_to user_course_path(current_user, @course)
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
      redirect_to user_path(current_user)
    elsif @course.update_attributes(params[course_to_unit: params[:course]])
      redirect_to edit_course_unit_path(@course)
    else
      flash[:error] = "Sorry, there was a mistake with teh form"
      render 'edit'
    end

  end

  def destroy

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

end
