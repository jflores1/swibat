class CoursesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new
    @course = current_user.courses.build(params[:course])
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

  end

  def destroy

  end

end
