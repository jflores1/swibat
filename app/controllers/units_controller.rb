class UnitsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_current_user_course
  load_and_authorize_resource

  def new
    @unit = @course.units.new

  end

  def create
    @unit = @course.units.new(params[:unit])
    if @unit.save && params[:submit]
      redirect_to user_path(current_user)
    elsif @unit.save && params[:move_on]
      redirect_to new_unit_lesson_path(@unit)
    else
      flash[:notice] = "Sorry, there was a mistake with the form"
      render 'new'
    end
  end

  def find_current_user_course
    @course = current_user.courses.find(params[:course_id])
  end


end
