class CoursesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index

  end

  def show
    @course = Course.find(params[:id])    
  end

  def new
    @course = current_user.courses.new
    @course.objectives.build
  end

  def create
    @course = current_user.courses.new(params[:course])
    if @course.save && params[:save_and_return]
      redirect_to user_path(current_user)
    elsif @course.save && params[:course_to_unit]
      redirect_to new_course_unit_path(@course)
    else
      flash[:notice] = "Sorry, there was a mistake with the form"
      render 'new'
    end
  end

  def edit

  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes!(params[:save_and_return]=>:course)
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

end
